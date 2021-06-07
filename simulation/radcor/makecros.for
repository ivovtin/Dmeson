C
C#####################################################
C   Make file with Cross Section for library RADCOR
C             ENERGY - sqrt(S) (MeV)
C          SIGMA - Cross Section Process
C#####################################################
C
            IMPLICIT NONE
            INTEGER *4 N,LOU
            REAL *8 ENERGY,SIGMA,CR3pi
            LOU=12
C=====================================================
C    Open File, for example e+e- ---> pi+pi-pi0
C=====================================================
            OPEN(UNIT=LOU,FILE='m:cr3pi.rad',
     *           STATUS='NEW')
            N=1
            ENERGY=4.0D2
1           SIGMA=CR3pi(ENERGY)
C=====================================================
C         CR2PI - function calculate
C       cross section e+e- ---> pi+pi-
C=====================================================
            WRITE(LOU,2) N,ENERGY,SIGMA
            ENERGY=ENERGY+0.5D0
            N=N+1
            IF(ENERGY.LT.1.4D3)GO TO1
2           FORMAT(2x,I5,2x,F7.2,2x,F9.4)
            CLOSE(LOU)
            END
