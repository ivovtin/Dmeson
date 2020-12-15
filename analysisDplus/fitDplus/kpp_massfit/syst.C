{
  FILE* file = fopen("syst.dat","r");

  int n=0;
  while (!feof(file)) {
    char name[256];
    float m0,m,em,d0,d,ed,cmcorr;
    if (fscanf(file,"%s %f %f %f %f %f %f",name,&m0,&m,&em,&d0,&d,&ed)) {
      float mcorr = 1869.4 + (m-m0) - 0.005*(d-d0);
      if (n==0) cmcorr = mcorr;
      else {
        printf("%s: %f (%f - %f)\n", name, mcorr-cmcorr, mcorr, cmcorr);
      }
    }
    n++;
  }
  
  fclose(file);
}
