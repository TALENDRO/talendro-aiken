TODO: AIKEN ProjectInit Cancel && arbitraion offchain

TODO: AIKEN: must send usr_configNFT back to original address for (Talendro token, arbitrator nft minter)
TODO: PROJECTINIT Burn case shouldnot burn when no projectDatum input found with somecondition like pay:none or etc.
TODO: milestone project in holding contract

```mermaid
graph LR
    T[Talendro]
    C4mint((Mint))
    C4spend((Spend))
    C1(IdentificationNFT)
    C2(ArbitratorNFT)
    C3(TalendroUserNFT)
    C4(ProjectInit)
    C5(Milestone Contract)

    Pinit(Project Init)
    c4c01(Must have Talendro User Token)
    c4c02(Must have Correct Datum)
    c4c03(Must mint 2 tokens clt_ & dev_)
    c4c04(dev_ token should go to script_output)
    c4c05(if project_datum.pay == ada, should go to script output , if pay is None than skil this part)
    c4c11(must have Talendro Token)
    c4c12(must send locked ada to milestonecontract if project_datum.pay == None else holding_contract)
    c4c13(same datum except project_datum.developer to holding_contract)
    c4c14(project_datum.developer must be singer)
    PAct(Project Accept)

    MCreate(Milestone Create)
    MCplt(Milestone Complete)
    PCnl(Project Cancel)
    PcnlB(Project Cancel before Minting)

    MC1((Mint))
    MC2((Spend))

    MC01(ProjectDatum doesn't change except milestone,current milestone)
    MC02(Should mint 2 token for each milestone)
    MC03(must have Talendro Token)
    MC04(dev_ token goes to Project_datum.developer)
    MC05(output.projectdatum.current_milestone.pay == ada , in script output)
    MC06(must have inoput from own address)

    MC11(CLT will mint milestone token)
    MC12(output should go to holding contract)
    MC13(must be minting some milestone token)

    MC3((Mint))
    MC21(must burn 1 pair of dev_ & clt_ milestone)
    MC22(output should go to HoldinContract with next milestone pay)
    MC23(output_datum will have updated current miletstone and milestone status == True)
    MC24(HoldingContract output should have currentMilstone pay)

    MC4((Mint))
    MC31(Burn all the milestone token received)
    MC32(check datum.currentmilestone and developer is None and pay for incomplete milestone as 0)

    MC51((developer))
    MC52((client))

    MC53((spend))
    MC54((spend))

    MC61(must send dev_project token)
    MC62(update datum_developer = None)
    MC63(must burn clt_ & dev_ project token)
    MC64(check datum.developer is None)



    T --> C1
    T --> C2
    T --> C3
    T --> C4
    T --> C5
    C4 --> Pinit
    Pinit --> C4mint
    C4mint --> c4c01
    C4mint --> c4c02
    C4mint --> c4c03
    C4mint --> c4c04
    C4mint --> c4c05
    C4spend --> c4c11
    C4spend --> c4c12
    C4spend --> c4c13
    C4spend --> c4c14
    C4 --> PAct
    PAct --> C4spend


    C5 --> MCreate
    C5 --> MCplt
    C5 --> PCnl
    C5 --> PcnlB

    MCreate --> MC2
    MCreate --> MC1

    MC1 --> MC01
    MC1 --> MC02
    MC1 --> MC03
    MC1 --> MC04
    MC1 --> MC05
    MC1 --> MC06

    MC2 --> MC11
    MC2 --> MC12
    MC2 --> MC13

    MCplt --> MC3
    MC3 --> MC21
    MC3 --> MC22
    MC3 --> MC23
    MC3 --> MC24

    PCnl --> MC4
    MC4 --> MC31
    MC4 --> MC32

    PcnlB --> MC51
    PcnlB --> MC52

    MC51 --> MC53
    MC52 --> MC54

    MC53 --> MC61
    MC53 --> MC62

    MC54 --> MC63
    MC54 --> MC64

```
