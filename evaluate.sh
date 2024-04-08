#env /bin/bash
#
############################################################
# Help                                                     #
############################################################
#

tools=(--tools=\"hevm-bitwuzla,halmos,kontrol\")
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

Graphs () {
    echo "Generating graphs"
    todo="./gen_graphs.py --verbose --pretty"
    echo "Running: $todo"
    $todo
    echo "DONE generating graphs"
    echo "You can now view all graphs in folder graphs/"
}

Full () {
    echo "Full tests, needs 24h"
    echo "You need $memoutmb of free memory for this to run."
    todo=(./bench.py --verbose -t 1000 "${tools[@]}" -m "$memoutmb")
    echo "Running: ${todo[@]}"
    ${todo[@]}
    echo "DONE with Full tests!"
    Graphs
}

Brief () {
    echo "Brief tests, needs 1h"
    echo "You need $memoutmb MB of free memory for this to run."
    todo=(./bench.py --verbose -t 40 "${tools[@]}" -m "$memoutmb")
    echo "Running: ${todo[@]}"
    ${todo[@]}
    echo "DONE with Brief tests!"
    Graphs
}

Smoketest () {
    echo "Smoke testing. Needs only time for full build and then quick run"
    echo "You need $memoutmb MB of free memory for this to run."
    # sleep 5
    todo=(./bench.py --verbose "${tools[@]}" -m "$memoutmb" --tests \"storage-unsafe.sol:C:proveMappingAccess\" )
    echo "Running: ${todo[@]}"
    ${todo[@]}
    echo "DONE with smoke test!"
    Graphs
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
