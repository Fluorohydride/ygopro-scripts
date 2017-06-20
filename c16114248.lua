--ペア・サイクロイド
function c16114248.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c16114248.ffilter,2,true)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
end
function c16114248.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_MACHINE) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
