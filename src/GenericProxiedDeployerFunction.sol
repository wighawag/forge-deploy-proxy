// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-deploy/Deployer.sol";
import {DefaultDeployerFunction, DeployOptions, PrivateDeployOptions} from "forge-deploy/DefaultDeployerFunction.sol";
import "./ForgeDeploy_EIP173Proxy.sol";

import "forge-std/console.sol";

struct ProxyOptions {
    address owner;
}

struct ProxyOptionsOnTag {
    address owner;
    string onTag;
}

struct ProxyOptionsWithImplementation {
    address owner;
    address implementation;
}

struct FullProxyOptions {
    address owner;
    string onTag;
    address implementation;
}

struct DeploymentData {
    string name;
    string artifact;
    bytes args;
}

library GenericProxiedDeployerFunction {
    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        FullProxyOptions memory options
    ) internal returns (address payable deployed) {
        return _deploy(deployer, name, artifact, args, options, PrivateDeployOptions({deterministic: false, salt: 0}));
    }

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    /// @param deployOptions create options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        FullProxyOptions memory options,
        DeployOptions memory deployOptions
    ) internal returns (address payable deployed) {
        return _deploy(
            deployer,
            name,
            artifact,
            args,
            options,
            PrivateDeployOptions({deterministic: true, salt: deployOptions.salt})
        );
    }

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxyOptions memory options
    ) internal returns (address payable deployed) {
        return _deploy(
            deployer,
            name,
            artifact,
            args,
            FullProxyOptions({owner: options.owner, onTag: "*", implementation: address(0)}),
            PrivateDeployOptions({deterministic: false, salt: 0})
        );
    }

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    /// @param deployOptions create options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxyOptions memory options,
        DeployOptions memory deployOptions
    ) internal returns (address payable deployed) {
        return _deploy(
            deployer,
            name,
            artifact,
            args,
            FullProxyOptions({owner: options.owner, onTag: "*", implementation: address(0)}),
            PrivateDeployOptions({deterministic: true, salt: deployOptions.salt})
        );
    }

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxyOptionsOnTag memory options
    ) internal returns (address payable deployed) {
        return _deploy(
            deployer,
            name,
            artifact,
            args,
            FullProxyOptions({owner: options.owner, onTag: options.onTag, implementation: address(0)}),
            PrivateDeployOptions({deterministic: false, salt: 0})
        );
    }

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    /// @param deployOptions create options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxyOptionsOnTag memory options,
        DeployOptions memory deployOptions
    ) internal returns (address payable deployed) {
        return _deploy(
            deployer,
            name,
            artifact,
            args,
            FullProxyOptions({owner: options.owner, onTag: options.onTag, implementation: address(0)}),
            PrivateDeployOptions({deterministic: true, salt: deployOptions.salt})
        );
    }

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxyOptionsWithImplementation memory options
    ) internal returns (address payable deployed) {
        return _deploy(
            deployer,
            name,
            artifact,
            args,
            FullProxyOptions({owner: options.owner, onTag: "*", implementation: options.implementation}),
            PrivateDeployOptions({deterministic: false, salt: 0})
        );
    }

    /// @notice generic deploy function that save it using the deployer contract
    /// @param deployer contract that keep track of the deployments and save them
    /// @param name the deployment's name that will stored on disk in <deployments>/<context>/<name>.json
    /// @param artifact forge's artifact path <solidity file>.sol:<contract name>
    /// @param args encoded aergument for the contract's constructor
    /// @param options proxy options
    /// @param deployOptions create options
    function deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        ProxyOptionsWithImplementation memory options,
        DeployOptions memory deployOptions
    ) internal returns (address payable deployed) {
        return _deploy(
            deployer,
            name,
            artifact,
            args,
            FullProxyOptions({owner: options.owner, onTag: "*", implementation: options.implementation}),
            PrivateDeployOptions({deterministic: true, salt: deployOptions.salt})
        );
    }

    // --------------------------------------------------------------------------------------------
    // PRIVATE
    // --------------------------------------------------------------------------------------------
    Vm private constant vm = Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    function _deploy(
        Deployer deployer,
        string memory name,
        string memory artifact,
        bytes memory args,
        FullProxyOptions memory options,
        PrivateDeployOptions memory deployOptions
    ) private returns (address payable deployed) {
        // TODO return newDeployed ?
        if (deployer.isTagEnabled(options.onTag)) {
            deployed = _deployProxy(
                deployer, DeploymentData({name: name, artifact: artifact, args: args}), options, deployOptions
            );

            // console.log("existing proxy:");
            // console.log(existingProxy.addr);
            address implementation = options.implementation;

            if (implementation == address(0)) {
                string memory implName = string.concat(name, "_Implementation");
                Deployment memory existingImpl = deployer.get(implName);
                bytes memory data = bytes.concat(vm.getCode(artifact), args);
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
            }

            address proxyCurrentImpl = address(
                uint160(uint256(vm.load(deployed, 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)))
            );
            if (proxyCurrentImpl != implementation) {
                address proxyOwner = options.owner;
                if (proxyOwner == address(0)) {
                    proxyOwner = msg.sender;
                }

                DefaultDeployerFunction.prepareCall(deployer, proxyOwner);
                // TODO extra call data (upgradeToAndCall)
                EIP173Proxy(payable(deployed)).upgradeTo(implementation);
                // TODO trigger a change in abi on the main contract // => _Implementation will trigger that ?

                deployer.save(name, deployed, artifact, "", ""); // new artifact

                // console.log("-- upgraded --");
            }
        } else {
            return DefaultDeployerFunction.deploy(deployer, name, artifact, args);
        }
    }

    function _deployProxy(
        Deployer deployer,
        DeploymentData memory data,
        FullProxyOptions memory options,
        PrivateDeployOptions memory deployOptions
    ) private returns (address payable deployed) {
        string memory proxyName = string.concat(data.name, "_Proxy");
        Deployment memory existingProxy = deployer.get(proxyName);

        if (existingProxy.addr != address(0)) {
            return existingProxy.addr;
        }

        // we ensure we are not overriding an existing deployment
        require(
            deployer.getAddress(data.name) == address(0),
            string.concat("trying to deploy a proxy on an existing contract: ", data.name)
        );

        address proxyOwner = options.owner;
        if (proxyOwner == address(0)) {
            proxyOwner = msg.sender;
        }

        address initialImplementation = options.implementation;
        if (initialImplementation == address(0)) {
            string memory implName = string.concat(data.name, "_Implementation");
            deployer.ignoreDeployment(implName);
            initialImplementation = DefaultDeployerFunction.deploy(deployer, implName, data.artifact, data.args);
        }

        // TODO extra call data
        bytes memory proxyArgs = abi.encode(initialImplementation, proxyOwner, bytes(""));
        if (deployOptions.deterministic) {
            deployed = DefaultDeployerFunction.deploy(
                deployer,
                proxyName,
                "ForgeDeploy_EIP173Proxy.sol:EIP173Proxy",
                proxyArgs,
                DeployOptions({salt: deployOptions.salt})
            );
        } else {
            deployed = DefaultDeployerFunction.deploy(
                deployer, proxyName, "ForgeDeploy_EIP173Proxy.sol:EIP173Proxy", proxyArgs
            );
        }

        // bytecode 0x indicate proxy
        deployer.save(data.name, deployed, data.artifact, "", "");
    }
}
