void combination()
{
    combinationD0();
    cout<<"------------------------------"<<endl;
    combinationDplus();
}

void combinationD0()
{
    float weight1;
    float weight2;

    float sigma_stat_total;
    float sigma_syst_total;

    float M1 = 1864.95;
    float sigma_stat1 = 0.270;
    float sigma_syst1 = 0.106;

    float M2 = 1865.30;
    float sigma_stat2 = 0.300;
    float sigma_syst2 = 0.031;

    weight1 = 1./(pow(sigma_stat1,2) + pow(sigma_syst1,2));
    weight2 = 1./(pow(sigma_stat2,2) + pow(sigma_syst2,2));

    cout<<"weight1="<<weight1<<endl;
    cout<<"weight2="<<weight2<<endl;

    //weigts to  1
    float sum_weights = (weight1+weight2);
    weight1 = weight1/sum_weights;
    weight2 = weight2/sum_weights;

    cout<<"Weights corrected to 1:"<<endl;
    cout<<"weight1="<<weight1<<endl;
    cout<<"weight2="<<weight2<<endl;

    float M_comb = weight1*M1 + weight2*M2;

    sigma_stat_total = sqrt(pow(weight1,2)*pow(sigma_stat1,2) + pow(weight2,2)*pow(sigma_stat2,2));
    sigma_syst_total = sqrt(pow(weight1,2)*pow(sigma_syst1,2) + pow(weight2,2)*pow(sigma_syst2,2));

    cout<<"Result for D0-meson:"<<endl;
    cout<<"M_comb="<<M_comb<<endl;
    cout<<"sigma_stat_total="<<sigma_stat_total<<endl;
    cout<<"sigma_syst_total="<<sigma_syst_total<<endl;
}


void combinationDplus()
{
    float weight1;
    float weight2;

    float sigma_stat_total;
    float sigma_syst_total;

    float M1 = 1869.58;
    float sigma_stat1 = 0.360;
    float sigma_syst1 = 0.130;

    float M2 = 1869.49;
    float sigma_stat2 = 0.490;
    float sigma_syst2 = 0.172;

    weight1 = 1./(pow(sigma_stat1,2) + pow(sigma_syst1,2));
    weight2 = 1./(pow(sigma_stat2,2) + pow(sigma_syst2,2));

    cout<<"weight1="<<weight1<<endl;
    cout<<"weight2="<<weight2<<endl;

    //to  1
    float sum_weights = (weight1+weight2);
    weight1 = weight1/sum_weights;
    weight2 = weight2/sum_weights;

    cout<<"Weights corrected to 1:"<<endl;
    cout<<"weight1="<<weight1<<endl;
    cout<<"weight2="<<weight2<<endl;

    float M_comb = weight1*M1 + weight2*M2;

    sigma_stat_total = sqrt(pow(weight1,2)*pow(sigma_stat1,2) + pow(weight2,2)*pow(sigma_stat2,2));
    sigma_syst_total = sqrt(pow(weight1,2)*pow(sigma_syst1,2) + pow(weight2,2)*pow(sigma_syst2,2));

    cout<<"Result for Dplus-meson:"<<endl;
    cout<<"M_comb="<<M_comb<<endl;
    cout<<"sigma_stat_total="<<sigma_stat_total<<endl;
    cout<<"sigma_syst_total="<<sigma_syst_total<<endl;
}

