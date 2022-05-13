import faker from "@faker-js/faker";
import prisma from "@prisma/client";

// Quantity of rows by table
const ACCOUNT_QUANTITY = 100;
const SECTOR_QUANTITY = 50;
const TRANSFER_QUANTITY = 1000;

// Set locale to generate data by region
faker.setLocale("pt_BR");

// Database connection
const client = new prisma.PrismaClient();

// Array of fake data
const sectors: prisma.sector[] = [];
const accounts: prisma.account[] = [];
const transfers: prisma.transfer[] = [];

async function main() {
  // Start time
  console.time("start");

  // Generate fake data
  generateSectors();
  generateAccounts();
  generateTransfers();

  // Delete all data previus in database
  await client.transfer.deleteMany();
  await client.account.deleteMany();
  await client.sector.deleteMany();

  // Insert new data in database
  await client.sector.createMany({ data: sectors });
  await client.account.createMany({ data: accounts });
  await client.transfer.createMany({ data: transfers });

  // End timer
  console.timeEnd("start");
}

main();

// Function for generate fake sectors
function generateSectors() {
  for (let i = 0; i < SECTOR_QUANTITY; i++) {
    sectors.push({
      id: faker.datatype.uuid(),
      name: faker.company.bsBuzz(),
    });
  }
}

// Function for generate fake accounts
async function generateAccounts() {
  for (let i = 0; i < ACCOUNT_QUANTITY; i++) {
    const index = Math.floor(Math.random() * sectors.length);

    accounts.push({
      account_agency: faker.finance.account(5),
      account_number: faker.finance.account(8),
      id: faker.datatype.uuid(),
      owner: sectors[index].id,
    });
  }
}

// Function for generate fake transfer
async function generateTransfers() {
  const indexAccountDestiny = Math.floor(Math.random() * ACCOUNT_QUANTITY);
  const indexACcountOrigin = Math.floor(Math.random() * ACCOUNT_QUANTITY);

  for (let i = 0; i < TRANSFER_QUANTITY; i++) {
    transfers.push({
      account_origin: accounts[indexACcountOrigin].id,
      account_destiny: accounts[indexAccountDestiny].id,
      amount: faker.finance.amount(100, 10000, 2),
      id: faker.datatype.uuid(),
    });
  }
}
