#!/bin/bash

# search root Download dir for files ending in .zip
options=( $(find ~/Downloads/*.zip -maxdepth 1 -print0 | xargs -0) )

select opt in "${options[@]}" "Quit" ; do
    if (( REPLY == 1 + ${#options[@]} )) ; then
        exit
    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
        echo  "Extracting $opt which is file $REPLY"
        bn=$(basename $opt)
        cd ~/Downloads
        # full name of file
        echo $bn
        # strip file extension
        echo "${bn%.*}"
        # 7zip required and locatable in path. Extracting to folder in the same dir and the same name of zip.
        7z.exe x ./$bn -o${bn%.*}
        cd ${bn%.*} && ls
        # convert the key to rsa, will prompt for password
        openssl rsa -in ./${bn%.*}.key -out ./${bn%.*}.rsa.key
        # import cert to acm
        jout=$(aws acm import-certificate --certificate fileb://${bn%.*}.crt --certificate-chain fileb://${bn%.*}-chain.pem --private-key fileb://${bn%.*}.rsa.key)
        # get arn for new cert, jq required
        arn=`echo $jout | jq -r '.CertificateArn'`
        # add to LB
        while true; do
          read -p "Add to the load balancer? ([Y]es, [C]ancel)" ans
          case $ans in
            [Yy]* ) aws elbv2 add-listener-certificates --listener-arn <replace with listener arn> \
                    --certificates CertificateArn=$arn; break;;
            [Cc]* ) exit;;
            * ) echo "Answer [Y]es or [C]ancel to Cancel";;
          esac
          echo "Completed."
        done
        break
    else
      echo "Invalid option. Try another one."
    fi
done
