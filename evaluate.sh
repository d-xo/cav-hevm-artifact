#env /bin/bash
#
############################################################
# Help                                                     #
############################################################
#

tools="--tools=\"hevm-bitwuzla,halmos,kontrol\""
#
Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "./evaluate.sh [--smoke-test][--brief][--full]"
   echo "--smoke-test  Check if installation is correct"
   echo "--brief       Check results by running for ~1h"
   echo "--full        Full run, takes ~24h"
   echo ""
}

Full () {
    echo "Full tests, needs 24h"
    echo "You need 16GB of free memory for this to run."
    todo="./bench.py --timeout 1000 $tools"
    echo "Running: $todo"
}

Brief () {
    echo "Full tests, needs 1h"
    echo "You need 16GB of free memory for this to run."
    todo="./bench.py --timeout 40 $tools"
    echo "Running: $todo"
}

Smoketest () {
    echo "Smoke testing."
    echo "You need 16GB of free memory for this to run."
    todo="./bench.py --timeout 4 --test=whatever $tools"
    echo "Running: $todo"
}

# Get the options
while getopts ":hfbs-:" option; do
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
