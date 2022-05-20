-- CreateTable
CREATE TABLE "account" (
    "id" UUID NOT NULL,
    "account_number" TEXT NOT NULL,
    "account_agency" TEXT NOT NULL,
    "owner" UUID NOT NULL,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sector" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "sector_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transfer" (
    "id" UUID NOT NULL,
    "account_origin" UUID NOT NULL,
    "account_destiny" UUID NOT NULL,
    "amount" TEXT NOT NULL,

    CONSTRAINT "transfer_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "account" ADD CONSTRAINT "account_owner_fkey" FOREIGN KEY ("owner") REFERENCES "sector"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "transfer" ADD CONSTRAINT "transfer_account_destiny_fkey" FOREIGN KEY ("account_destiny") REFERENCES "account"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "transfer" ADD CONSTRAINT "transfer_account_origin_fkey" FOREIGN KEY ("account_origin") REFERENCES "account"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
