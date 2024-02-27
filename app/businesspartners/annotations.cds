using nnrg as service from '../../srv/nnrg';

annotate service.BusinessPartners with {
    State @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'States',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : State_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Code',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'Description',
            },
        ],
    }
};
