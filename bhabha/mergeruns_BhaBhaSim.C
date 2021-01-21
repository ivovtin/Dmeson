#include <iostream>
#include <string>

void mergeruns_BhaBhaSim(){
    string outfile="/spool/users/ovtin/outDmeson/simulation/BhaBha/merge_all_simBhaBha.root";
    string inruns;
    string inrunsAll;

    for(int i=1; i<=1; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23275-23286_1.0_0.8/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=2; i<=4; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23287-23317_1.0_0.3/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=5; i<=9; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23318-23369_1.4_1.0/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=10; i<=11; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23403-23430_1.3_1.0/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=12; i<=15; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23431-23472_1.2_0.9/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=16; i<=19; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23473-23522_2.2_1.5/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=20; i<=22; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23523-23550_2.0_1.3/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=23; i<=24; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23551-23569_1.8_1.1/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=25; i<=26; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23645-23681_1.2_0.81/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=27; i<=29; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23682-23715_1.5_0.8/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=30; i<=32; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23716-23742_1.5_1.7/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=36; i<=37; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23839-23862_1.6_1.3/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=38; i<=40; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23863-23885_1.1_0.7/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=41; i<=42; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23886-23905_1.0_0.9/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=43; i<=44; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23906-23943_1.9_1.5/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=45; i<=50; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24621-24675_2.9_2.4/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=51; i<=54; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24676-24712_1.6_1.1/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=55; i<=58; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24790-24845_1.6_1.0/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=59; i<=61; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24846-24875_1.4_1.0/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=62; i<=64; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24876-24916_2.4_1.7/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=65; i<=69; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25045-25090_2.3_1.6/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=70; i<=71; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25091-25114_1.6_1.1/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=72; i<=75; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25115-25157_1.6_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=76; i<=78; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25158-25185_1.6_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=79; i<=84; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25186-25241_1.5_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=85; i<=89; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25352-25395_1.4_1.1/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=90; i<=91; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25396-25416_1.9_1.3/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=92; i<=95; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25417-25438_1.6_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=96; i<=98; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25439-25508_1.9_1.3/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=99; i<=100; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25559-25574_1.5_1.1/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=101; i<=103; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25575-25608_1.2_1.0/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=104; i<=107; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25609-25640_1.6_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=108; i<=109; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25641-25663_1.6_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=110; i<=113; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25664-25719_1.6_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=114; i<=116; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/26051-26079_1.8_1.3/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=117; i<=120; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/26080-26102_1.6_1.2/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }
    for(int i=121; i<=124; i++)
    {
	inruns=(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/26103-26134_1.4_1.0/psi3770_to_simBhaBha_%d.root ",i).Data());
	inrunsAll.append(inruns);
    }

    cout<<"inrunsAll="<<inrunsAll<<endl;
    gSystem->Exec(TString::Format("hadd %s %s",outfile,inrunsAll));
    gSystem->Exec("ls -ltr");
}
