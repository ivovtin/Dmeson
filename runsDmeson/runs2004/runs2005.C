void runs2005()
{
    ofstream out("allrunsDmeson2005", ios::app);
    //ofstream out(TString::Format("runBkgDmeson%d",N).Data(), ios::app);
    if (out.is_open())
    {
	for (int i=4100; i<=4707; i++)
	{
	    cout << i << endl;
	    out << i << endl;
	}
    }
    out.close();
    cout << "End of program" << endl;
}
