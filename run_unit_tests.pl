#!/usr/bin/perl

$num_args = $#ARGV + 1;

my $first_parameter;
my $secound_parameter;

if ( !(($num_args == 2) || ($num_args == 0)) ) {
  print "\nUsage: check_unit_test [<-j><num>]  ";
  exit;
}
if(  $num_args == 0 )
{
        $first_parameter="";
        $secound_parameter="";
}
if(  $num_args == 2 )
{
        $first_parameter= $ARGV[0];
        $secound_parameter=$ARGV[1];
}

## Generating arm_debug_flags.h ##
unless (-e "/vob/tetra/su_vris_mcore/arm-size-optimize-000/generated/arm_debug_flags.h")
{
    system ("mkdir /vob/tetra/su_vris_mcore/arm-size-optimize-000");
    system ("mkdir /vob/tetra/su_vris_mcore/arm-size-optimize-000/generated");
    system ("cp /vob/tetra/su_vris_mcore/include/arm_debug_flags.template /vob/tetra/su_vris_mcore/arm-size-optimize-000/generated/arm_debug_flags.h");
}

$gtest_dir = "/vob/tetra/su_ergo/atcmd/unit_tests/gtest";
$cxxtest_dir = "/vob/tetra/su_ergo/atcmd/unit_tests";
#=======================================================================
sub checking_gtest
{
        print "\n=============================";
        print "\nChecking Gtest unit tests ...";
        print "\n=============================\n";

        chdir $gtest_dir;
        if (!(system ("make $first_parameter $secound_parameter")))
        {
                print "\n========================";
                print "\nGtest successful !";
                print "\n========================\n";
                return true; 
        }
        else 
        {
                print "\n================================";
                print "\nGtest failure !";
                print "\n================================\n";
                return false;
        }
}
#=======================================================================
sub checking_CXXtest
{
        print "\n=============================";
        print "\nChecking CXX unit tests ...";
        print "\n=============================\n";

        ## For generating resources ##
        system ("make -C /vob/tetra/su_vris_mcore drm_resources $first_parameter $secound_parameter");

        chdir $cxxtest_dir;
        if (!(system ("cmake .")))
        {
                if (!(system ("make $first_parameter $secound_parameter")))
                {
                        print "\n========================";
                        print "\nCXX unit tests build successful !";
                        print "\n========================\n";
                        if (!(system ("ctest")))
                        {
                                print "\n======================";
                                print "\nALL CXX tests PASSED !";
                                print "\n======================\n";
                                return true;
                        }
                        {
                                print "\n======================";
                                print "\nCXX tests FAILURES   !";
                                print "\n=====================\n";
                                return false;
                        }
                }
                else 
                {
                        print "\n================================";
                        print "\nCXX unit_tests build failure !";
                        print "\n================================\n";
                        return false;
                }
        }
        else 
        {
                print "\n================================";
                print "\ncmake failure !";
                print "\n================================\n";
                return false;
        }
}
#=======================================================================

if(&checking_gtest())
{
        &checking_CXXtest();
}
