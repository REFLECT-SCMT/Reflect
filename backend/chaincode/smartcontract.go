package chaincode

import(
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api/contractapi"
)

type SmartContract struct{
	contractapi.Contract
}

type Asset struct{
	ID string `json:"ID"`
	Owner string `json:"Owner"`
	Quantity int `json:"Quantity"`
	AppraisedValue int `json:"AppraisedValue"`
}

func (sc *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error{
	assets := []Asset{
		{ID: "asset1", Owner: "Tomoko", Quantity: 10, AppraisedValue: 300},
		{ID: "asset2", Owner: "Brad", Quantity: 6, AppraisedValue: 400},
		{ID: "asset3", Owner: "Jin Soo", Quantity: 18, AppraisedValue: 500},
		{ID: "asset4", Owner: "Max", Quantity: 2, AppraisedValue: 600},
		{ID: "asset5", Owner: "Adriana", Quantity: 26, AppraisedValue: 700},
		{ID: "asset6", Owner: "Michel", Quantity: 8, AppraisedValue: 800},
	}

	for _, asset := range assets{
		assetJson, err := json.Marshal(asset);if err != nil{
			return err
		}

		err = ctx.GetStub().PutStub(asset.ID, assetJson); if err != nil{
			return err
		}
	}
	return nil
}

func (sc *SmartContract) CreateAsset(ctx contractapi.TransactionContextInterface, id string, owner string, quantity int, appraisedvalue int) error{
	exists, err := sc.ExistsAsset(ctx, id);if err != nil{
		return err
	}
	if exists{
		return fmt.Errorf("Asset %s already exits", id)
	}

	asset := Asset{
		ID : id, Owner : owner, Quantity : quantity, AppraisedValue : appraisedvalue,
	}

	assetJson, err:= json.Marshal(asset); if err != nil{
		return err
	}
	
	return ctx.GetStub().PutState(id, assetJson)
}

func (sc *SmartContract) ReadAsset(ctx contractapi.TransactionContextInterface, id string) (*Asset, error){
	assetJson, err := ctx.GetStub().GetState(id); if err != nil{
		return nil, fmt.Errorf("Failed to read World State: %v", err)
	}
	if assetJson == nil{
		return nil, fmt.Errorf("Asset %s does not exist", id)
	}

	var asset *Asset
	err = json.Unmarshal(assetJson,&asset); if err != nil{
		return nil, err
	}
	return asset, nil
}

func (sc *SmartContract) UpdateAsset(ctx contractapi.TransactionContextInterface, id string, owner string, quantity int, appraisedvalue int) error{
	exists, err := sc.ExistsAsset(ctx, id);if err != nil{
		return err
	}
	if !exists{
		return fmt.Errorf("Asset %s already exits", id)
	}

	asset := Asset{
		ID : id, Owner : owner, Quantity : quantity, AppraisedValue : appraisedvalue,
	}

	assetJson, err:= json.Marshal(asset); if err != nil{
		return err
	}
	
	return ctx.GetStub().PutState(id, assetJson)
}

func (sc *SmartContract) DelAsset(ctx contractapi.TransactionContextInterface, id string) error{
	exists, err := sc.ExistsAsset(ctx, id); if err != nil{
		return nil
	}
	if !exists{
		return fmt.Errorf("Asset %s does not exist", id)
	}

	return ctx.GetStub().DelState(id)
}

func (sc *SmartContract) TransAsset(ctx contractapi.TransactionContextInterface, id, newOwner string) error{
	asset, err := sc.ReadAsset(id); if err != nil{
		return err
	}
	asset.Owner = newOwner
	assetJson, err = json.Marshal(asset); if err != nil{
		return err
	}
	return ctx.GetStub().PutState(id, assetJson)
}

func (sc *SmartContract) ExistsAsset(ctx contractapi.TransactionContextInterface, id string) (bool, error){
	assetJson, err := ctx.GetStub().GetState(id); if err != nil{
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}
	return assetJson !=nil, nil
}

func (sc *SmartContract) QueryAllAsset(ctx contractapi.TransactionContextInterface) ([]Asset, error){
	resultsIterator, err := ctx.GetStub().GetStateByRange("","")
	if err != nil{
		return nil, err
	}
	defer resultsIterator.Close()

	var asset []*Asset
	for resultsIterator.HasNext(){
		querResponse, err := resultsIterator.Next(); if err != nil{
			return nil, err
		}
		var asset *Asset
		err = json.Unmarshal(querResponse.Value, &asset); if err != nil{
			return nil, err
		}
		assets := append(assets, asset)
	}
	return assets, nil
}
