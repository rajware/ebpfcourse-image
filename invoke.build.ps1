param(
    $VersionMajor = (property VERSION_MAJOR "1"),
    $VersionMinor = (property VERSION_MINOR "0"),
    $BuildNumber = (property BUILD_NUMBER  "1"),
    $PatchString = (property PATCH_NUMBER  ""),
    $MatsyaSourcePath = (property MATSYA_SOURCE_PATH ""),
    $MatsyaKeyPairPath = (property MATSYA_KEYPAIR_PATH "")
)

$VersionString = "$($VersionMajor).$($VersionMinor).$($BuildNumber)$($PatchString)"

$VMDescription = @"
Bhringa Image version $VersionString

Matsya base image: $MatsyaSourcePath
"@

# Synopsis: Show usage
task . {
    Write-Host "Usage: Invoke-Build vbox|hyperv|keys|clean-vbox|clean-hyperv|clean-keys|clean"
}

# Synopsis: Build VirtualBox image
task vbox -Outputs "output-bhringa-vbox/Bhringa-$($VersionString).ova" -Inputs bhringa-vbox.pkr.hcl, {
    exec {
        packer build `
            -only=matsya-vm.virtualbox-iso.matsya-vbox `
            -var "iso-url=$($OSISOPath)" `
            -var "iso-checksum=$($OSISOChecksum)" `
            -var "vm-version=$($VersionString)" `
            -var "vm-description=$($VMDescription)" `
            matsya-vbox.pkr.hcl
    }
}

# Synopsis: Build HyperV image
task hyperv  { #-Outputs "output-bhringa-hyperv/bhringa-hyperv.zip" -Inputs bhringa-hyperv.pkr.hcl, {
    Write-Debug "DEBUGGGG"
    exec {
        packer build `
            -var "source-path=$MatsyaSourcePath" `
            -var "root-certificate=$MatsyaKeyPairPath" `
            -var "vm-version=$VersionString" `
            -var "vm-description=$$VM_DESCRIPTION" `
            bhringa-hyperv.pkr.hcl

    }
}

# Synopsis: Delete built VirtualBox image
task clean-vbox {
    Remove-Item -Recurse -Force output-bhringa-vbox -ErrorAction Ignore
}

# Synopsis: Delete built Hyper-V image
task clean-hyperv {
    Remove-Item -Recurse -Force output-bhringa-hyperv -ErrorAction Ignore
}

# Synopsis: Delete all output
task clean clean-vbox, clean-hyperv
