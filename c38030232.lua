--天威龍－サハスラーラ
---@param c Card
function c38030232.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WYRM),2,4)
	--can not be attack target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c38030232.atcon)
	e1:SetValue(c38030232.attg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c38030232.attg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(38030232,0))
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,38030232)
	e3:SetTarget(c38030232.tktg)
	e3:SetOperation(c38030232.tkop)
	c:RegisterEffect(e3)
end
function c38030232.atfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function c38030232.atcon(e)
	return Duel.IsExistingMatchingCard(c38030232.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c38030232.attg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c38030232.tkfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,38030233,0x12c,TYPES_TOKEN_MONSTER,c:GetBaseAttack(),0,4,RACE_WYRM,ATTRIBUTE_LIGHT)
end
function c38030232.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c38030232.tkfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c38030232.tkfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.SelectTarget(tp,c38030232.tkfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c38030232.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local atk=tc:GetBaseAttack()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then atk=0 end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,38030233,0x12c,TYPES_TOKEN_MONSTER,atk,0,4,RACE_WYRM,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,38030233)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
