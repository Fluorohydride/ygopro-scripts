--ベルキャットファイター
function c22953211.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c22953211.lcheck)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22953211,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdocon)
	e1:SetTarget(c22953211.tktg)
	e1:SetOperation(c22953211.tkop)
	c:RegisterEffect(e1)
end
function c22953211.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_TOKEN)
end
function c22953211.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22953212,0,0x4011,2000,2000,4,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22953211.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22953212,0,0x4011,2000,2000,4,RACE_MACHINE,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,22953212)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
