
import Vapor
import Fluent


struct ContaController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {
        let contas = routes.grouped("contas")

        contas.get(use: listarTodas)
        contas.get("corrente", use: listarContasCorrentes)
        contas.get(":id", "saldo", use: saldo)
        contas.get("poupanca", use: listarContasPoupanca)
        contas.get("internacional", use: listarContasInternacionais)
        contas.post(":id", "depositar", use: depositar)
        contas.post(":id", "sacar", use: sacar)
        contas.post("corrente", use: criarContaCorrente)
        contas.post("poupanca", use: criarContaPoupanca)
        contas.post("internacional", use: criarContaInternacional)
        
    }
    
    func listarTodas(req: Request) async throws -> [ContaResponseDTO] {
        do {
            let correntes = try await ContaCorrente.query(on: req.db).all()
            req.logger.info("Correntes carregadas: \(correntes.count)")

            let poupancas = try await ContaPoupanca.query(on: req.db).all()
            req.logger.info("Poupancas carregadas: \(poupancas.count)")

            let internacionais = try await ContaCorrenteInternacional.query(on: req.db).all()
            req.logger.info("Internacionais carregadas: \(internacionais.count)")

            let contasCorrentes = try correntes.map {
                ContaResponseDTO(id: try $0.requireID(), nome: $0.nome, saldo: $0.saldo, tipo: "corrente")
            }

            let contasPoupancas = try poupancas.map {
                ContaResponseDTO(id: try $0.requireID(), nome: $0.nome, saldo: $0.saldo, tipo: "poupanca")
            }

            let contasInternacionais = try internacionais.map {
                ContaResponseDTO(id: try $0.requireID(), nome: $0.nome, saldo: $0.saldo, tipo: "internacional")
            }

            return (contasCorrentes + contasPoupancas + contasInternacionais)
                .sorted { $0.nome.localizedCaseInsensitiveCompare($1.nome) == .orderedAscending }
        } catch {
            req.logger.report(error: error)
            throw error
        }
    }

    func listarContasCorrentes(req: Request) async throws -> [ContaResponseDTO] {
        let contas = try await ContaCorrente.query(on: req.db).all()
        return try contas.map {
            ContaResponseDTO(
                id: try $0.requireID(),
                nome: $0.nome,
                saldo: $0.saldo,
                tipo: "corrente"
            )
        }
    }
    
    func listarContasPoupanca(req: Request) async throws -> [ContaResponseDTO] {
        let contas = try await ContaPoupanca.query(on: req.db).all()
        return try contas.map {
            ContaResponseDTO(id: try $0.requireID(), nome: $0.nome, saldo: $0.saldo, tipo: "poupanca")
        }
    }
    
    func listarContasInternacionais(req: Request) async throws -> [ContaResponseDTO] {
        let contas = try await ContaCorrenteInternacional.query(on: req.db).all()
        return try contas.map {
            ContaResponseDTO(id: try $0.requireID(), nome: $0.nome, saldo: $0.saldo, tipo: "internacional")
        }
    }

    func criarContaCorrente(req: Request) async throws -> ResultadoDTO {
        let dto = try req.content.decode(CriarContaDTO.self)
        let conta = ContaCorrente(nome: dto.nome)
        try await conta.save(on: req.db)
        return ResultadoDTO(sucesso: true, id: conta.id, novoValor: conta.saldo, erro: nil)
    }
    
    func criarContaPoupanca(req: Request) async throws -> ResultadoDTO {
        let dto = try req.content.decode(CriarContaDTO.self)
        let conta = ContaPoupanca(nome: dto.nome)
        try await conta.save(on: req.db)

        return ResultadoDTO(
            sucesso: true,
            id: conta.id,
            novoValor: conta.saldo,
            erro: nil
        )
    }

    func criarContaInternacional(req: Request) async throws -> ResultadoDTO {
        let dto = try req.content.decode(CriarContaDTO.self)
        let conta = ContaCorrenteInternacional(nome: dto.nome)
        try await conta.save(on: req.db)

        return ResultadoDTO(
            sucesso: true,
            id: conta.id,
            novoValor: conta.saldo,
            erro: nil
        )
    }

    func saldo(req: Request) async throws -> ResultadoDTO {
        let id = try req.parameters.require("id", as: UUID.self)

        if let conta = try await ContaCorrente.find(id, on: req.db) {
            return ResultadoDTO(from: conta.saldoAtual())
        }

        if let conta = try await ContaPoupanca.find(id, on: req.db) {
            return ResultadoDTO(from: conta.saldoAtual())
        }

        if let conta = try await ContaCorrenteInternacional.find(id, on: req.db) {
            return ResultadoDTO(from: conta.saldoAtual())
        }

        throw Abort(.notFound, reason: "Conta não encontrada.")
    }

    func depositar(req: Request) async throws -> ResultadoDTO {
        let id = try req.parameters.require("id", as: UUID.self)
        let dto = try req.content.decode(DepositoDTO.self)

        if let conta = try await ContaCorrente.find(id, on: req.db) {
            let resultado = conta.depositar(valor: dto.valor)
            if case .sucesso = resultado { try await conta.save(on: req.db) }
            return ResultadoDTO(from: resultado)
        }

        if let conta = try await ContaPoupanca.find(id, on: req.db) {
            let resultado = conta.depositar(valor: dto.valor)
            if case .sucesso = resultado { try await conta.save(on: req.db) }
            return ResultadoDTO(from: resultado)
        }

        if let conta = try await ContaCorrenteInternacional.find(id, on: req.db) {
            let resultado = conta.depositar(valor: dto.valor)
            if case .sucesso = resultado { try await conta.save(on: req.db) }
            return ResultadoDTO(from: resultado)
        }

        throw Abort(.notFound, reason: "Conta não encontrada.")
    }

    func sacar(req: Request) async throws -> ResultadoDTO {
        let id = try req.parameters.require("id", as: UUID.self)
        let dto = try req.content.decode(SaqueDTO.self)

        if let conta = try await ContaCorrente.find(id, on: req.db) {
            let validaValor = ValidaValorPositivoHandler()
            let validaSaldo = ValidaSaldoSuficienteHandler()
            let validaNegativo = ValidaContaNaoNegativadaHandler()
            let executa = ExecutaSaqueHandler()

            validaValor.proximo = validaSaldo
            validaSaldo.proximo = validaNegativo
            validaNegativo.proximo = executa

            let resultado = validaValor.handle(
                request: SaqueRequest(valor: dto.valor, conta: conta)
            )

            if case .sucesso = resultado {
                try await conta.save(on: req.db)
            }

            return ResultadoDTO(from: resultado)
        }

        if let conta = try await ContaPoupanca.find(id, on: req.db) {
            let resultado = conta.sacar(valor: dto.valor)
            if case .sucesso = resultado { try await conta.save(on: req.db) }
            return ResultadoDTO(from: resultado)
        }

        if let conta = try await ContaCorrenteInternacional.find(id, on: req.db) {
            let resultado = conta.sacar(valor: dto.valor)
            if case .sucesso = resultado { try await conta.save(on: req.db) }
            return ResultadoDTO(from: resultado)
        }

        throw Abort(.notFound, reason: "Conta não encontrada.")
    }
}

struct CriarContaDTO: Content {
    let nome: String
}
