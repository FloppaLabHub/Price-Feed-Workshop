import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { AggregatorV3Mock, WorkshopToken, Crowdsale } from "../typechain-types";

describe("Crowdsale Test", async () => {
  let owner: SignerWithAddress;
  let user: SignerWithAddress;

  let aggregator: AggregatorV3Mock;
  let workshopToken: WorkshopToken;
  let crowdsale: Crowdsale;

  before(async () => {
    [owner, user] = await ethers.getSigners();

    const AggregatorContract = await ethers.getContractFactory('AggregatorV3Mock');
    aggregator = await AggregatorContract.deploy();

    const WorkshopTokenContract = await ethers.getContractFactory('WorkshopToken');
    workshopToken = await WorkshopTokenContract.deploy();

    const CrowdsaleContract = await ethers.getContractFactory("Crowdsale");
    crowdsale = await CrowdsaleContract.deploy(aggregator.address, workshopToken.address);
  })

  it("Setup started balance", async () => {
    const balanceOfOwner = await workshopToken.balanceOf(owner.address);
    await workshopToken.transfer(crowdsale.address, balanceOfOwner);
    const crowdsaleBalance = await workshopToken.balanceOf(crowdsale.address);
    expect(balanceOfOwner).to.equal(crowdsaleBalance).to.equal(ethers.utils.parseEther("100000"));
  })

  it("Buy check", async () => {
    await crowdsale.connect(user).buyTokens({ value: ethers.utils.parseEther("1")});
    const userBalance = await workshopToken.balanceOf(user.address);
    
    expect(userBalance).to.equal(ethers.utils.parseUnits("10"));
  })
})