#env /bin/bash
#
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: evaluate --smoke-test/--brief/--full"
   echo "Check for sanity: ./evaluate.sh --smoke-test"
   echo "Check briefly: ./evaulate.sh --brief"
   echo "Full run: ./evaluate --full"
   echo ""
}

Full () {
    echo "Full tests, needs 24h"
    echo "You need 16GB of memory for this to run."
    todo="./bench.py --timeout 1000"
    echo "Running: $todo"
}

Brief () {
    echo "Full tests, needs 1h"
    echo "You need 16GB of memory for this to run."
    todo="./bench.py --timeout 40"
    echo "Running: $todo"
}

Smoketest () {
    echo "Smoke testing."
    echo "You need 16GB of memory for this to run."
    todo="./bench.py --timeout 4 --test=whatever"
    echo "Running: $todo"
}

# Get the options
while getopts ":h-:" option; do
   case $option in
      h|help) # display Help
         Help
         exit;;
      f|full)
         Full
         exit;;
      b|brief)
         Brief
         exit;;
      s|smoke-test)
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
