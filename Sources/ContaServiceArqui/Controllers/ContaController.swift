
import Vapor
import Fluent

struct ContaController: RouteCollection {
    
    func listarContasCorrentes(req: Request) async throws -> [ContaCorrente] {
        try await ContaCorrente.query(on: req.db).all()
    }

    
    func boot(routes: RoutesBuilder) throws {
        let contas = routes.grouped("contas")

        contas.post("corrente", use: criarContaCorrente)
        contas.get(":id", "saldo", use: consultarSaldo)
        contas.post(":id", "depositar", use: depositar)
        contas.post(":id", "sacar", use: sacar)

        // nova rota
        contas.get("corrente", use: listarContasCorrentes)
    }

    // POST /contas/corrente
    func criarContaCorrente(req: Request) async throws -> ResultadoDTO {
        let dto = try req.content.decode(CriarContaDTO.self)
        let conta = ContaCorrente(nome: dto.nome)
        try await conta.save(on: req.db)
        return ResultadoDTO(sucesso: true, id: conta.id, novoValor: conta.saldo, erro: nil)
    }

    // POST /contas/:id/sacar
    func sacar(req: Request) async throws -> ResultadoDTO {
        let id  = try req.parameters.require("id", as: UUID.self)
        let dto = try req.content.decode(SaqueDTO.self)

        // ✅ guard let em vez de .unwrap()
        guard let conta = try await ContaCorrente.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Conta não encontrada.")
        }

        let validaValor    = ValidaValorPositivoHandler()
        let validaSaldo    = ValidaSaldoSuficienteHandler()
        let validaNegativo = ValidaContaNaoNegativadaHandler()
        let executa        = ExecutaSaqueHandler()
        validaValor.proximo    = validaSaldo
        validaSaldo.proximo    = validaNegativo
        validaNegativo.proximo = executa

        let resultado = validaValor.handle(
            request: SaqueRequest(valor: dto.valor, conta: conta)
        )

        if case .sucesso = resultado {
            try await conta.save(on: req.db)
        }

        return ResultadoDTO(from: resultado)
    }

    // POST /contas/:id/depositar
    func depositar(req: Request) async throws -> ResultadoDTO {
        let id  = try req.parameters.require("id", as: UUID.self)
        let dto = try req.content.decode(DepositoDTO.self)

        guard let conta = try await ContaCorrente.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Conta não encontrada.")
        }

        let resultado = conta.depositar(valor: dto.valor)

        if case .sucesso = resultado {
            try await conta.save(on: req.db)
        }

        return ResultadoDTO(from: resultado)
    }

    // GET /contas/:id/saldo
    func saldo(req: Request) async throws -> ResultadoDTO {
        let id = try req.parameters.require("id", as: UUID.self)

        guard let conta = try await ContaCorrente.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Conta não encontrada.")
        }

        return ResultadoDTO(from: conta.saldoAtual())
    }
}

struct CriarContaDTO: Content {
    let nome: String
}
