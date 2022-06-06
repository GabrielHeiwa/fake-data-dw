import faker from "@faker-js/faker"
import prisma from "@prisma/client"

const CARGOS = 7
const CLIENTES = 100
const COLABORADORES = 15
const FORNECEDORES = 15
const PEDIDOS_CLIENTES = 70
const PEDIDOS_CLIENTES_PRODUTOS = 70
const PEDIDOS_FORNECEDORES = 100
const PEDIDOS_FORNECEDORES_PRODUTOS = 100
const PRODUTOS = 90
const NOTAS_FISCAIS = 170

faker.setLocale("pt_BR");

const client = new prisma.PrismaClient();
const dados = {
  cargos: [],
  clientes: [],
  colaboradores: [],
  fornecedores: [],
  notas_fiscais: [],
  produtos: [],
  pedidos_clientes: [],
  pedidos_fornecedores: [],
  pedidos_clientes_produtos: [],
  pedidos_fornecedores_produtos: [],
};

async function main() {
  console.time("start")

  await delete_all_tables()
  await generate_fake_data()
  await populate_all_tables()

  console.timeEnd("start")

  async function generate_fake_data() {
    await fake_cargos()
    await fake_colaboradores()
    await fake_clientes()
    await fake_fornecedores()
    await fake_nota_fiscais()
    await fake_produtos()
    await fake_pedidos_clientes()
    await fake_pedidos_clientes_produtos()
    await fake_pedidos_fornecedores()
    await fake_pedidos_fornecedores_produtos()
  }

  async function delete_all_tables() {
    await client.pedidos_clientes_produtos.deleteMany()
    await client.pedidos_fornecedores_produtos.deleteMany()
    await client.pedidos_clientes.deleteMany()
    await client.pedidos_fornecedores.deleteMany()
    await client.produtos.deleteMany()
    await client.notas_fiscais.deleteMany()
    await client.fornecedores.deleteMany()
    await client.clientes.deleteMany()
    await client.colaboradores.deleteMany()
    await client.cargos.deleteMany()
  }

  async function populate_all_tables() {
    await client.cargos.createMany({ data: dados['cargos'] })
    await client.colaboradores.createMany({ data: dados['colaboradores'] })
    await client.clientes.createMany({ data: dados['clientes'] })
    await client.fornecedores.createMany({ data: dados['fornecedores'] })
    await client.notas_fiscais.createMany({ data: dados['notas_fiscais'] })
    await client.produtos.createMany({ data: dados['produtos'] })
    await client.pedidos_clientes.createMany({ data: dados['pedidos_clientes'] })
    await client.pedidos_fornecedores.createMany({ data: dados['pedidos_fornecedores'] })
    await client.pedidos_clientes_produtos.createMany({ data: dados['pedidos_clientes_produtos'] })
    await client.pedidos_fornecedores_produtos.createMany({ data: dados['pedidos_fornecedores_produtos'] })
  }
}

main();

async function fake_cargos() {
  console.time("Gerando cargos...");

  for (let i = 0; i < CARGOS; i++) {
    dados["cargos"].push({
      id: faker.datatype.uuid(),
      nome: faker.word.adjective(),
    });
  }

  console.timeEnd("Gerando cargos...");
}

async function fake_colaboradores() {
  console.time("Gerando colaboradores...");

  for (let i = 0; i < COLABORADORES; i++) {
    const cargo_id = dados["cargos"][faker.datatype.number({ min: 0, max: CARGOS - 1 })].id;

    dados["colaboradores"].push({
      id: faker.datatype.uuid(),
      nome: faker.name.findName(),
      cpf: faker.finance.account(11),
      status: faker.datatype.boolean(),
      admissao: faker.date.past(),
      demissao: faker.datatype.boolean()
        ? faker.date.soon(
          faker.datatype.number({ min: 1, max: 3650, precision: 0 })
        )
        : null,
      cargo: cargo_id,
    });
  }

  console.timeEnd("Gerando colaboradores...");
}

async function fake_clientes() {
  console.time("Gerando clientes...");

  for (let i = 0; i < CLIENTES; i++) {
    dados["clientes"].push({
      id: faker.datatype.uuid(),
      nome: faker.name.findName(),
      cpf: faker.finance.account(11),
      bairro: faker.address.country(),
      cidade: faker.address.cityName(),
      estado: faker.address.state(),
      nascimento: faker.date.past(faker.datatype.number({ min: 18, max: 55 }))
    });
  }

  console.timeEnd("Gerando clientes...");
}

async function fake_fornecedores() {
  console.time("Gerando fornecedores...");

  for (let i = 0; i < FORNECEDORES; i++) {
    dados["fornecedores"].push({
      id: faker.datatype.uuid(),
      nome: faker.company.companyName(),
      cnpj: faker.finance.account(8) + '0001'
    });
  }

  console.timeEnd("Gerando fornecedores...");
}

async function fake_nota_fiscais() {
  console.time("Gerando notas fiscais...")

  for (let i = 0; i < NOTAS_FISCAIS; i++) {
    let codigo
    do {
      codigo = faker.datatype.number({ min: 1, max: 5000 }).toString()
    } while (dados['notas_fiscais'].findIndex(note => note.codigo === codigo) !== -1)

    dados['notas_fiscais'].push({
      id: faker.datatype.uuid(),
      codigo,
    })
  }

  console.timeEnd("Gerando notas fiscais...")

}

async function fake_produtos() {
  console.time("Gerando produtos...");

  for (let i = 0; i < PRODUTOS; i++) {
    dados["produtos"].push({
      id: faker.datatype.uuid(),
      nome: faker.commerce.product(),
      quantidade: parseInt(faker.finance.amount(0, 1000, 0)),
      preco: faker.finance.amount(0, 500, 2),
    });
  }

  console.timeEnd("Gerando produtos...");
}

async function fake_pedidos_clientes() {
  console.time('Gerando os pedidos...')

  for (let i = 0; i < PEDIDOS_CLIENTES; i++) {
    const colaborador_id = dados['colaboradores'][faker.datatype.number({ min: 0, max: COLABORADORES - 1 })].id
    const cliente_id = dados['clientes'][faker.datatype.number({ min: 0, max: CLIENTES - 1 })].id

    let codigo
    do {
      codigo = faker.datatype.number({ min: 0, max: 1000 }).toString()
    } while (dados['pedidos_clientes'].findIndex(request => request.codigo === codigo) !== -1);

    let notas_fiscais_codigo
    do {
      notas_fiscais_codigo = dados['notas_fiscais'][faker.datatype.number({ min: 0, max: NOTAS_FISCAIS - 1 })].codigo
    } while (dados['pedidos_clientes'].findIndex(notes => notes.notas_fiscais_codigo === notas_fiscais_codigo) !== -1)

    dados['pedidos_clientes'].push({
      id: faker.datatype.uuid(),
      colaborador_id,
      cliente_id,
      codigo,
      notas_fiscais_codigo,
      data: faker.date.recent(faker.datatype.number({ min: 1, max: 90 }))
    })
  }

  console.timeEnd('Gerando os pedidos...')
}

async function fake_pedidos_fornecedores() {
  console.time("Gerando pedidos_fornecedores...")

  for (let i = 0; i < PEDIDOS_FORNECEDORES; i++) {

    const colaborador_id = dados['colaboradores'][faker.datatype.number({ min: 0, max: COLABORADORES - 1 })].id
    const fornecedor_id = dados['fornecedores'][faker.datatype.number({ min: 0, max: FORNECEDORES - 1 })].id

    let codigo
    do {
      codigo = faker.datatype.number({ min: 0, max: 1000 }).toString()
    } while (dados['pedidos_fornecedores'].findIndex(request => request.codigo === codigo) !== -1);

    let notas_fiscais_codigo
    do {
      notas_fiscais_codigo = dados['notas_fiscais'][faker.datatype.number({ min: 0, max: NOTAS_FISCAIS - 1 })].codigo
    } while (dados['pedidos_fornecedores'].findIndex(notes => notes.notas_fiscais_codigo === notas_fiscais_codigo) !== -1)

    dados['pedidos_fornecedores'].push({
      id: faker.datatype.uuid(),
      fornecedor_id,
      colaborador_id,
      data: faker.date.recent(faker.datatype.number({ min: 1, max: 90 })),
      notas_fiscais_codigo,
      codigo
    })
  }

  console.timeEnd("Gerando pedidos_fornecedores...")
}

async function fake_pedidos_clientes_produtos() {
  console.time('Gerando pedidos_clientes_produtos...')

  for (let i = 0; i < PEDIDOS_CLIENTES_PRODUTOS; i++) {
    let pedidos_clientes_codigo
    do {
      pedidos_clientes_codigo = dados['pedidos_clientes'][faker.datatype.number({ min: 0, max: PEDIDOS_CLIENTES - 1 })].codigo
    } while (dados['pedidos_clientes_produtos'].findIndex(pcp => pcp.pedidos_clientes_codigo === pedidos_clientes_codigo) !== -1)

    const productQuantity = faker.datatype.number({ min: 1, max: 6 })

    for (let j = 0; j < productQuantity; j++) {
      const produto = dados['produtos'][faker.datatype.number({ min: 0, max: PRODUTOS - 1 })]
      const quantidade = faker.datatype.number({ min: 1, max: 3 })
      dados['pedidos_clientes_produtos'].push({
        id: faker.datatype.uuid(),
        produto_id: produto.id,
        quantidade,
        pedidos_clientes_codigo,
        total: produto.preco * quantidade
      })
    }
  }

  console.timeEnd('Gerando pedidos_clientes_produtos...')
}

async function fake_pedidos_fornecedores_produtos() {
  console.time("Gerando pedidos_fornecedores_produtos...")

  for (let i = 0; i < PEDIDOS_FORNECEDORES_PRODUTOS; i++) {
    let pedidos_fornecedores_codigo
    do {
      pedidos_fornecedores_codigo = dados['pedidos_fornecedores'][faker.datatype.number({ min: 0, max: PEDIDOS_FORNECEDORES - 1 })].codigo
    } while (dados['pedidos_fornecedores_produtos'].findIndex(pfp => pfp.pedidos_fornecedores_codigo === pedidos_fornecedores_codigo) !== -1)

    const productQuantity = faker.datatype.number({ min: 1, max: 6 })

    for (let j = 0; j < productQuantity; j++) {
      const produto = dados['produtos'][faker.datatype.number({ min: 0, max: PRODUTOS - 1 })]
      const quantidade = faker.datatype.number({ min: 1, max: 3 })

      dados['pedidos_fornecedores_produtos'].push({
        id: faker.datatype.uuid(),
        produto_id: produto.id,
        quantidade,
        total: produto.preco * quantidade,
        pedidos_fornecedores_codigo,
      })
    }

  }
  console.timeEnd("Gerando pedidos_fornecedores_produtos...")
}
// 5aSc6C72
