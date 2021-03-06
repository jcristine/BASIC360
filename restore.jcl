//HERC01R JOB MSGCLASS=H,MSGLEVEL=(1,1),CLASS=A,NOTIFY=HERC01,          00010000
//   USER=HERC01,PASSWORD=CUL8TR
//********************************************************************  00020000
//*                                                                     00030000
//*   COPY THE BASIC360 DISTRIBUTION FROM TAPE TO DISK                  00040000
//*                                                                     00050000
//*   ALL DATASET CREATED BY THIS JOB WILL BE CREATED WITH THE          00060000
//*   HIGH LEVEL QUALIFIER OF HERC01 ON VOLUME PUB000.  YOU CAN         00070000
//*   DO A CHANGE ALL TO USE A DIFFERENT QUALIFIER OR VOLUME.           00080000
//*                                                                     00090000
//*   THE DISTRIBUTION TAPE CONTAINS THE FOLLOWING DATASETS:            00100000
//*   LABEL   DSN        DESCRIPTION                                    00110000
//*       1   DISTRO1    THIS JCL                                       00120000
//*       2   DISTRO2    IEBCOPY UNLOADED HERC01.BASIC360.LOADLIB       00130000
//*       3   DISTRO3    IEBCOPY UNLOADED HERC01.BASIC360.PLI           00140000
//*                                                                     00150000
//********************************************************************  00160000
//*                                                                     00170000
//*   STEP 1 - DELETE THE EXISTING PDS IF THEY EXIST                    00180000
//*                                                                     00190000
//********************************************************************  00200000
//STEP01   EXEC  PGM=IDCAMS                                             00210000
//SYSPRINT DD SYSOUT=*                                                  00220000
//SYSIN    DD *                                                         00230000
   DELETE HERC01.BASIC360.LOADLIB   NONVSAM PURGE                       00240000
   DELETE HERC01.BASIC360.PLI       NONVSAM PURGE                       00250000
   SET LASTCC = 0                                                       00260000
   SET MAXCC = 0                                                        00270000
//********************************************************************  00280000
//*                                                                     00290000
//*   STEP 2 - ALLOCATE THE NEW PDS                                     00300000
//*                                                                     00310000
//********************************************************************  00320000
//STEP02   EXEC  PGM=IEFBR14                                            00330000
//DD2 DD DSN=HERC01.BASIC360.LOADLIB,DISP=(NEW,CATLG,DELETE),           00340000
//       UNIT=3350,VOL=SER=PUB000,SPACE=(TRK,(25,15,15)),               00350000
//       DCB=(RECFM=U,BLKSIZE=19068)                                    00360000
//DD3 DD DSN=HERC01.BASIC360.PLI,DISP=(NEW,CATLG,DELETE),               00370000
//       UNIT=3350,VOL=SER=PUB000,SPACE=(TRK,(30,30,30)),               00380000
//       DCB=(RECFM=FB,LRECL=80,BLKSIZE=400)                            00390000
//********************************************************************  00400000
//*                                                                     00410000
//*  THIS WILL RESTORE THE TAPE TO PDS USING IEBCOPY                    00420000
//*                                                                     00430000
//********************************************************************  00440000
//STEP03  EXEC PGM=IEBCOPY                                              00450000
//IN02   DD DSN=DISTRO2,DISP=(OLD,KEEP),                                00460000
//       UNIT=(480,,DEFER),VOL=(,RETAIN,SER=BAS220),                    00470000
//       LABEL=(2,SL)                                                   00480000
//OUT02  DD DSN=HERC01.BASIC360.LOADLIB,DISP=SHR                        00490000
//*                                                                     00500000
//IN03   DD DSN=DISTRO3,DISP=(OLD,KEEP),                                00510000
//       UNIT=(480,,DEFER),VOL=(,RETAIN,SER=BAS220),                    00520000
//       LABEL=(3,SL)                                                   00530000
//OUT03  DD DSN=HERC01.BASIC360.PLI,DISP=SHR                            00540000
//*                                                                     00550000
//SYSPRINT DD SYSOUT=*                                                  00560000
//SYSIN  DD *                                                           00570000
 COPY INDD=IN02,OUTDD=OUT02                                             00580000
 COPY INDD=IN03,OUTDD=OUT03                                             00590000
//*                                                                     00600000
