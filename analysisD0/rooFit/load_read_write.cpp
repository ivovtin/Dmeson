void read_par(char* filename, int npar, double* par, double* epar) {
  FILE* file = fopen(filename, "r");
  if (!file) {
    printf("Error opening file %s\n", filename);
    return;
  }
  printf("Reading file %s\n", filename);

  for (int i=0; i<npar; i++) {
    int dummy;
    fscanf(file, "%d %lf %lf", &dummy, &par[i], &epar[i]);
    printf("%s : par(%d)=%f +- %f\n", filename, i, par[i], epar[i]);
  }
  fclose(file);
}

