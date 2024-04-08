#env /bin/bash
#
############################################################
# Help                                                     #
############################################################
#

tools="--tools=\"hevm-bitwuzla,halmos,kontrol\""
#
memoutmb="16000"
Help()
{
   # Display Help
   echo "NOTE: if you run with a >16 core machine, some things may NOT work"
   echo "      because the max memory will still be 16GB, but e.g. HEVM"
   echo "      will spin up more than 16 threads which may mem-out"
   echo "      For these cases, increase memory to n*1000, where N is"
   echo "      the core count of your chip"
   echo ""
   echo
   echo "./evaluate.sh [-m NUM][--smoke-test][--brief][--full]"
   echo "-m NUM        Max total memory in MB. Default: $memoutmb"
   echo "--smoke-test  Check if installation is correct"
   echo "--brief       Check results by running for ~1h"
   echo "--full        Full run, takes ~24h"
   echo ""
}



Full () {
    echo "Full tests, needs 24h"
    echo "You need $memoutmb of free memory for this to run."
    todo="./bench.py -t 1000 $tools -m $memoutmb"
    echo "Running: $todo"
}

Brief () {
    echo "Full tests, needs 1h"
    echo "You need $memoutmb MB of free memory for this to run."
    todo="./bench.py -t 40 $tools -m $memoutmb"
    echo "Running: $todo"
}

Smoketest () {
    echo "Smoke testing."
    echo "You need $memoutmb MB of free memory for this to run."
    todo="./bench.py --timeout 4 --test=whatever $tools -m $memoutmb"
    echo "Running: $todo"
}

# Get the options
while getopts ":hfbs-:m:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      f)
         Full
         exit;;
      b)
         Brief
         exit;;
      s)
         Smoketest
         exit;;
      m)
         memoutmb=${OPTARG}
         ;;
      -)
          case "${OPTARG}" in
            help)
              Help
              exit
              ;;
            smoke-test)
              Smoketest
              exit
              ;;
            brief)
              Brief
              exit
              ;;
            full)
              Full
              exit
              ;;
            *)
              echo "Invalid option: --$OPTARG"
              exit 1
              ;;
          esac
          ;;
      \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

echo "Error, you must run with some options. Please run with --help"
