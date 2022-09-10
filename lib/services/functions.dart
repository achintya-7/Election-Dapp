// ignore_for_file: unnecessary_import

import 'dart:async';
import 'dart:core';

import 'package:election/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString("assets/abi.json");
  String contractAddress = contractAddress_testnet;
  final contract = DeployedContract(ContractAbi.fromJson(abi, "Election"),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract, function: ethFunction, parameters: args),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

// CALLING OF FUNCTIONS

Future<String> startElection(String name, Web3Client ethClient) async {
  var response =
      await callFunction("startElection", [name], ethClient, owner_private_key);
  print("\n Election Started Succesfully! \n");
  return response;
}

Future<String> addCandinate(String name, Web3Client ethClient) async {
  var response =
      await callFunction("addCandinate", [name], ethClient, owner_private_key);
  print("\n Candinate added Succesfully! \n");
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunction("authorizeVoter",
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  print("\n Voter Authorized! \n");
  return response;
}

Future<List> getCandinateNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getNumCandinates', [], ethClient);
  return result;
}

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> vote(int candinateIndex, Web3Client ethClient,
    {String privateKey = voter_1_private_key}) async {
  var response = await callFunction(
      "vote", [BigInt.from(candinateIndex)], ethClient, privateKey);
  print("\nVote Counted Successfully!\n\n" + response + "\n\n");
  return response;
}
