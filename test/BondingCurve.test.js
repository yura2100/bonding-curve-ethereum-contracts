const {ethers} = require('hardhat');
const {expect} = require('chai');
const {deployContract} = require('@animoca/ethereum-contract-helpers/src/test/deploy');
const {loadFixture} = require('@animoca/ethereum-contract-helpers/src/test/fixtures');

describe('BondingCurve', function () {
  before(async function () {
    [deployer, other] = await ethers.getSigners();
  });

  const fixture = async function () {
    this.price = 50 * 10 ** 6;
    this.numerator = 5;
    this.denominator = 100;

    this.contract = await deployContract('BondingCurve', this.price, this.numerator, this.denominator);
  };

  beforeEach(async function () {
    await loadFixture(fixture, this);
  });

  describe('constructor', function () {
    it('sets initial price', async function () {
      expect(await this.contract.initialPrice()).to.equal(this.price);
    });

    it('sets slope numerator', async function () {
      expect(await this.contract.slopeNumerator()).to.equal(this.numerator);
    });

    it('sets slope denominator', async function () {
      expect(await this.contract.slopeDenominator()).to.equal(this.denominator);
    });

    it('sets initial owner', async function () {
      expect(await this.contract.owner()).to.equal(deployer.address);
    });
  });

  describe('setInitialPrice(uint256 price)', function () {
    it('reverts with "NotContractOwner" if the caller is not the owner', async function () {
      await expect(this.contract.connect(other).setInitialPrice(this.price))
        .to.revertedWithCustomError(this.contract, 'NotContractOwner')
        .withArgs(other.address);
    });

    context('when successful', function () {
      it('sets the initial price', async function () {
        const newPrice = 60 * 10 ** 6;
        await this.contract.setInitialPrice(newPrice);
        expect(await this.contract.initialPrice()).to.equal(newPrice);
      });

      it('emits a "InitialPriceSet" event', async function () {
        const newPrice = 60 * 10 ** 6;
        await expect(this.contract.setInitialPrice(newPrice)).to.emit(this.contract, 'InitialPriceSet').withArgs(newPrice, deployer.address);
      });
    });
  });

  describe('setSlopeNumerator(uint256 numerator)', function () {
    it('reverts with "NotContractOwner" if the caller is not the owner', async function () {
      await expect(this.contract.connect(other).setSlopeNumerator(this.numerator))
        .to.revertedWithCustomError(this.contract, 'NotContractOwner')
        .withArgs(other.address);
    });

    it('reverts with "LinearCurveZeroNumerator" if the numerator is zero', async function () {
      await expect(this.contract.setSlopeNumerator(0)).to.revertedWithCustomError(this.contract, 'LinearCurveZeroNumerator');
    });

    context('when successful', function () {
      it('sets the slope numerator', async function () {
        const newNumerator = 6;
        await this.contract.setSlopeNumerator(newNumerator);
        expect(await this.contract.slopeNumerator()).to.equal(newNumerator);
      });

      it('emits a "SlopeNumeratorSet" event', async function () {
        const newNumerator = 6;
        await expect(this.contract.setSlopeNumerator(newNumerator))
          .to.emit(this.contract, 'SlopeNumeratorSet')
          .withArgs(newNumerator, deployer.address);
      });
    });
  });

  describe('setSlopeDenominator(uint256 denominator)', function () {
    it('reverts with "NotContractOwner" if the caller is not the owner', async function () {
      await expect(this.contract.connect(other).setSlopeDenominator(this.denominator))
        .to.revertedWithCustomError(this.contract, 'NotContractOwner')
        .withArgs(other.address);
    });

    it('reverts with "LinearCurveZeroDenominator" if the denominator is zero', async function () {
      await expect(this.contract.setSlopeDenominator(0)).to.revertedWithCustomError(this.contract, 'LinearCurveZeroDenominator');
    });

    context('when successful', function () {
      it('sets the slope denominator', async function () {
        const newDenominator = 101;
        await this.contract.setSlopeDenominator(newDenominator);
        expect(await this.contract.slopeDenominator()).to.equal(newDenominator);
      });

      it('emits a "SlopeDenominatorSet" event', async function () {
        const newDenominator = 101;
        await expect(this.contract.setSlopeDenominator(newDenominator))
          .to.emit(this.contract, 'SlopeDenominatorSet')
          .withArgs(newDenominator, deployer.address);
      });
    });
  });

  describe('calculatePrice(uint256 totalSupply, uint256 amount)', function () {
    it('returns initial price if totalSupply is zero', async function () {
      expect(await this.contract.calculatePrice(0, 1)).to.equal(this.price);
    });

    it('returns the correct price', async function () {
      const totalSupply = 100;
      const expectedPrice = this.price + (totalSupply * this.numerator) / this.denominator;
      expect(await this.contract.calculatePrice(totalSupply, 1)).to.equal(expectedPrice);
    });
  });
});
