--騎甲虫隊降下作戦
---@param c Card
function c87240371.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,87240371+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c87240371.target)
	e1:SetOperation(c87240371.activate)
	c:RegisterEffect(e1)
end
function c87240371.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,64213018,0x170,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_INSECT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c87240371.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,64213018,0x170,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_INSECT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,87240372)
	local ec=aux.ExceptThisCard(e)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c87240371.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c87240371.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ec)
		and Duel.SelectYesNo(tp,aux.Stringid(87240371,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,c87240371.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,ec)
		Duel.BreakEffect()
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c87240371.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsAttackAbove(3000)
end
function c87240371.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
