--メタルフォーゼ・カーディナル
function c54401832.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe1),aux.FilterBoolFunction(Card.IsAttackBelow,3000),2,2,true)
end
