#include <iostream>
#include <string>

void mergeruns(){
    string outfile="psi3770_to_D0meson.root";
    string inruns;
    string inrunsAll;

    for(int i=1; i<=116; i++)
    {
	//inruns=++TString::Format("/spool/users/ovtin/outDmeson/psi3770_to_D0meson_%d.root ",i).Data());
	inruns=TString::Format("/spool/users/ovtin/outDmeson/psi3770_to_D0meson_%d.root ",i).Data());
        inrunsAll.append(inruns);
        cout<<"inruns="<<inruns<<endl;
    }
    cout<<"inrunsAll="<<inrunsAll<<endl;
    gSystem->Exec(TString::Format("hadd %s %s",outfile,inrunsAll));
    gSystem->Exec("ls -ltr");
}
