void reduce_list()
{
    string line;
    int i=0;
    int N=1;

    ifstream in("allrunsDmeson2005"); //signal
    if (in.is_open())
    {
	while (getline(in, line))
	{
	    i++;

	    cout << line << endl;
	    //if(i<=2)
	    if(i<=0)
	    {
		cout << i << endl;
		ofstream out(TString::Format("runDmeson%d",N).Data(), ios::app);
		//ofstream out(TString::Format("runBkgDmeson%d",N).Data(), ios::app);
		if (out.is_open())
		{
		    out << line << endl;
		}
		out.close();
	    }
	    else{
		ofstream out(TString::Format("runDmeson%d",N).Data(), ios::app);
		//ofstream out(TString::Format("runBkgDmeson%d",N).Data(), ios::app);
		if (out.is_open())
		{
		    out << line << endl;
		}
		out.close();
		i=0;
		N++;
	    }
	}
    }
    in.close();

    cout << "End of program" << endl;
}
