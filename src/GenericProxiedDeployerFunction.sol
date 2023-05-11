// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-deploy/Deployer.sol";
import {DefaultDeployerFunction, DeployOptions} from "forge-deploy/DefaultDeployerFunction.sol";
import "./ForgeDeploy_EIP173Proxy.sol";

struct ProxiedDeployOptions {
    string proxyOnTag;
    address proxyOwner;
}

library GenericProxiedDeployerFunction {
    using DeployerFunctions for Deployer;

    Vm constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    function deploy(
        Deployer storage deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxiedDeployOptions memory options
    ) internal returns (address payable deployed) {
        // TODO return newDeployed ?
        if (deployer.isTagEnabled(options.proxyOnTag)) {
            string memory proxyName = string.concat(name, "_Proxy");

            // console.log("tag enabled");
            Deployment memory existingProxy = deployer.get(proxyName);

            if (existingProxy.addr != address(0)) {
                deployed = upgradeIfDifferent(deployer, existingProxy, name, artifact, args, options);
                // console.log("-- upgraded --");
            } else {
                deployed = deployProxy(deployer, name, artifact, args, options);
            }
            deployer.save(name, deployed, artifact, "", ""); // new artifact
        } else {
            return DefaultDeployerFunction.deploy(deployer, name, artifact, args);
        }
    }

    function deployProxy(
        Deployer storage deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxiedDeployOptions memory options
    ) internal returns (address payable deployed) {
        string memory proxyName = string.concat(name, "_Proxy");
        string memory implName = string.concat(name, "_Implementation");
        // console.log("new proxy needed");
        deployer.ignoreDeployment(proxyName);
        deployer.ignoreDeployment(implName);
        address implementation = DefaultDeployerFunction.deploy(deployer, implName, artifact, args);
        // console.log("new implementation:");
        // console.log(implementation);
        // console.log(artifact);

        // TODO extra call data
        bytes memory proxyArgs = abi.encode(implementation, options.proxyOwner, bytes(""));
        deployed =
            DefaultDeployerFunction.deploy(deployer, proxyName, "ForgeDeploy_EIP173Proxy.sol:EIP173Proxy", proxyArgs);

        // bytecode 0x indicate proxy
        // console.log("new proxy:");
        // console.log(deployed);
        return deployed;
    }

    function upgradeIfDifferent(
        Deployer storage deployer,
        Deployment memory existingProxy,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxiedDeployOptions memory options
    ) private returns (address payable deployed) {
        string memory implName = string.concat(name, "_Implementation");
        bytes memory data = bytes.concat(vm.getCode(artifact), args);

        // console.log("existing proxy:");
        // console.log(existingProxy.addr);
        address implementation;
        Deployment memory existingImpl = deployer.get(implName);
        if (
            existingImpl.addr == address(0)
                || keccak256(bytes.concat(existingImpl.bytecode, existingImpl.args)) != keccak256(data)
        ) {
            // we will override the previous implementation
            deployer.ignoreDeployment(implName);
            // TODO implementation args
            implementation = DefaultDeployerFunction.deploy(deployer, implName, artifact, args);
            // console.log("new implementation for existing proxy:");
            // console.log(implementation);
            // console.log(artifact);
        } else {
            // console.log("reusing impl:");
            // console.log(existingImpl.addr);
            implementation = existingImpl.addr;
        }
        deployed = existingProxy.addr;
        if (deployer.autoBroadcast) {vm.broadcast(options.proxyOwner);}
        // TODO extra call data (upgradeToAndCall)
        EIP173Proxy(payable(deployed)).upgradeTo(implementation);
        // TODO trigger a change in abi on the main contract // => _Implementation will trigger that ?

        return deployed;
    }
}
