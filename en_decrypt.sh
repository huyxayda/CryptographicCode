#!/bin/bash

#create a key pair
createkeypair() {
    read -p "Enter the folder store your keys pairs (left empty if you want to store in current directory): " pathfolder

    if [[ ! -e $pathfolder && ! -z $pathfolder ]]; then 
        mkdir $pathfolder #if path not exist, create new one
    elif [[ -z $pathfolder ]]; then
        pathfolder=$(pwd) #if path is left empty, assign current directory
    fi

    cd $pathfolder


    #check keyname
    while true; do
        read -p "Enter your key name: " keyname

        if [[ -e "$keyname.key" ]]; then
            echo "This name has already been existed"
        else
            break
        fi
    done

    # generate private and public key
    openssl genrsa -out $keyname.key 4096
    openssl rsa -in $keyname.key -pubout -out $keyname.pubkey

}

# encryp file
encryption() {
    while true; do
        read -p "Enter the file name you want to encrypt: " fileinput
        if [[ ! -e $fileinput ]]; then
            echo "Your input file does not exist"
        else
            break
        fi
    done

    while true; do
        read -p "Enter your public key: " publickey
        if [[ ! -e $publickey ]]; then
            echo "Your input public key does not exist"
        else
            break
        fi  
    done

    openssl pkeyutl -encrypt -in $fileinput -pubin -inkey $publickey -out message.enc
}


#decrypt
decryption() {

    while true; do
        read -p "Enter the encrypted file name you want to decrypt: " encryptedfile
        if [[ ! -e $encryptedfile ]]; then
            echo "Your input file does not exist"
        else
            break
        fi
    done

    while true; do
        read -p "Enter your private key: " privatekey
        if [[ ! -e $privatekey ]]; then
            echo "Cannot find your private key"
        else
            break
        fi  
    done

    openssl pkeyutl -decrypt -in $encryptedfile -inkey $privatekey
}

#prompt

echo -e "1) Create a key pairs\n2) Encrypt a file\n3)Decrypt a file"
read -p "Let me know what you want to do [1,2 or 3]: " selopt

case $selopt in
    1) createkeypair;;
    2) encryption;;
    3) decryption;;
    *) echo "Invalid selection; exiting program" && exit 1
esac

exit 0