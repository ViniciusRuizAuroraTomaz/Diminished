-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'CUSTOMER');

-- CreateEnum
CREATE TYPE "ProductKind" AS ENUM ('GUITAR', 'BASS', 'PEDAL', 'AMPLIFIER', 'MICROPHONE');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'REFUNDED');

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'CUSTOMER',

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Brand" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Brand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "weight" DECIMAL(5,2) NOT NULL,
    "kind" "ProductKind" NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "stock" INTEGER NOT NULL DEFAULT 0,
    "brandId" INTEGER NOT NULL,
    "model" TEXT NOT NULL,
    "imageUrl" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GuitarSpecs" (
    "productId" UUID NOT NULL,
    "stringCount" INTEGER NOT NULL,
    "bodyMaterial" TEXT,
    "neckMaterial" TEXT,
    "fretboardMaterial" TEXT,
    "pickupConfiguration" TEXT,
    "pickupType" TEXT,
    "bridgeType" TEXT,
    "scaleLength" DOUBLE PRECISION,
    "fretCount" INTEGER,
    "orientation" TEXT,
    "hasActiveElectronics" BOOLEAN,
    "finish" TEXT,

    CONSTRAINT "GuitarSpecs_pkey" PRIMARY KEY ("productId")
);

-- CreateTable
CREATE TABLE "BassSpecs" (
    "productId" UUID NOT NULL,
    "stringCount" INTEGER NOT NULL,
    "bodyMaterial" TEXT,
    "neckMaterial" TEXT,
    "fretboardMaterial" TEXT,
    "pickupConfiguration" TEXT,
    "pickupType" TEXT,
    "bridgeType" TEXT,
    "scaleLength" DOUBLE PRECISION,
    "fretCount" INTEGER,
    "orientation" TEXT,
    "hasActiveElectronics" BOOLEAN,
    "finish" TEXT,

    CONSTRAINT "BassSpecs_pkey" PRIMARY KEY ("productId")
);

-- CreateTable
CREATE TABLE "AmplifierSpecs" (
    "productId" UUID NOT NULL,
    "powerWatts" INTEGER NOT NULL,
    "amplifierType" TEXT NOT NULL,
    "instrumentType" TEXT NOT NULL,
    "speakerSize" DOUBLE PRECISION,
    "speakerCount" INTEGER,
    "impedanceOhms" DOUBLE PRECISION,
    "channelCount" INTEGER,
    "hasEffects" BOOLEAN,
    "hasReverb" BOOLEAN,
    "hasHeadphoneOutput" BOOLEAN,
    "hasEffectsLoop" BOOLEAN,
    "connectivity" TEXT,

    CONSTRAINT "AmplifierSpecs_pkey" PRIMARY KEY ("productId")
);

-- CreateTable
CREATE TABLE "PedalSpecs" (
    "productId" UUID NOT NULL,
    "effectType" TEXT NOT NULL,
    "instrumentType" TEXT NOT NULL,
    "bypassType" TEXT,
    "powerSupply" TEXT,
    "voltage" INTEGER,
    "currentDrawMa" INTEGER,
    "inputCount" INTEGER,
    "outputCount" INTEGER,
    "stereo" BOOLEAN,
    "analogOrDigital" TEXT,
    "hasMidi" BOOLEAN,
    "hasUsb" BOOLEAN,
    "batteryPowered" BOOLEAN,

    CONSTRAINT "PedalSpecs_pkey" PRIMARY KEY ("productId")
);

-- CreateTable
CREATE TABLE "MicrophoneSpecs" (
    "productId" UUID NOT NULL,
    "microphoneType" TEXT NOT NULL,
    "polarPattern" TEXT NOT NULL,
    "frequencyResponseMin" INTEGER,
    "frequencyResponseMax" INTEGER,
    "sensitivity" DOUBLE PRECISION,
    "impedanceOhms" INTEGER,
    "connectionType" TEXT NOT NULL,
    "requiresPhantomPower" BOOLEAN,
    "maxSplDb" DOUBLE PRECISION,
    "wireless" BOOLEAN NOT NULL,

    CONSTRAINT "MicrophoneSpecs_pkey" PRIMARY KEY ("productId")
);

-- CreateTable
CREATE TABLE "FavoriteProducts" (
    "id" SERIAL NOT NULL,
    "productId" UUID NOT NULL,
    "userId" UUID NOT NULL,

    CONSTRAINT "FavoriteProducts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "orderStatus" "OrderStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deliveredAt" TIMESTAMP(3),

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrderItem" (
    "orderId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitPrice" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "OrderItem_pkey" PRIMARY KEY ("orderId","productId")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "FavoriteProducts_productId_userId_key" ON "FavoriteProducts"("productId", "userId");

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES "Brand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GuitarSpecs" ADD CONSTRAINT "GuitarSpecs_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BassSpecs" ADD CONSTRAINT "BassSpecs_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AmplifierSpecs" ADD CONSTRAINT "AmplifierSpecs_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PedalSpecs" ADD CONSTRAINT "PedalSpecs_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MicrophoneSpecs" ADD CONSTRAINT "MicrophoneSpecs_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FavoriteProducts" ADD CONSTRAINT "FavoriteProducts_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FavoriteProducts" ADD CONSTRAINT "FavoriteProducts_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
