--ユウ－Ai－
---@param c Card
function c32056070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--select effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32056070,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c32056070.target)
	c:RegisterEffect(e2)
end
function c32056070.filter(c,att,used)
	return c:GetBaseAttack()==2300 and c:IsRace(RACE_CYBERSE) and c:IsAttribute(att) and c:GetAttribute()&used==0
end
function c32056070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 and not eg:IsExists(c32056070.filter,1,nil,ATTRIBUTE_ALL,0) then return false end
	local b1=Duel.IsExistingMatchingCard(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11738490,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK)
	local used=Duel.GetFlagEffectLabel(tp,32056070)
	if used==nil then
		used=0
		Duel.RegisterFlagEffect(tp,32056070,RESET_PHASE+PHASE_END,0,1,used)
	end
	local att=0
	if b1 and eg:IsExists(c32056070.filter,1,nil,ATTRIBUTE_EARTH,used) then att=att|ATTRIBUTE_EARTH end
	if b1 and eg:IsExists(c32056070.filter,1,nil,ATTRIBUTE_WATER,used) then att=att|ATTRIBUTE_WATER end
	if b2 and eg:IsExists(c32056070.filter,1,nil,ATTRIBUTE_WIND,used) then att=att|ATTRIBUTE_WIND end
	if b2 and eg:IsExists(c32056070.filter,1,nil,ATTRIBUTE_LIGHT,used) then att=att|ATTRIBUTE_LIGHT end
	if b3 and eg:IsExists(c32056070.filter,1,nil,ATTRIBUTE_FIRE,used) then att=att|ATTRIBUTE_FIRE end
	if b3 and eg:IsExists(c32056070.filter,1,nil,ATTRIBUTE_DARK,used) then att=att|ATTRIBUTE_DARK end
	if chk==0 then return att>0 end
	if att&(att-1)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(32056070,1))
		att=Duel.AnnounceAttribute(tp,1,att)
	end
	used=used|att
	Duel.SetFlagEffectLabel(tp,32056070,used)
	if att&(ATTRIBUTE_EARTH+ATTRIBUTE_WATER)>0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetOperation(c32056070.attrop1)
	end
	if att&(ATTRIBUTE_WIND+ATTRIBUTE_LIGHT)>0 then
		e:SetCategory(0)
		e:SetOperation(c32056070.attrop2)
	end
	if att&(ATTRIBUTE_FIRE+ATTRIBUTE_DARK)>0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c32056070.attrop3)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	end
end
function c32056070.attrop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(math.ceil(tc:GetAttack()/2))
	tc:RegisterEffect(e1)
end
function c32056070.attrop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
end
function c32056070.attrop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11738490,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,32056071)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
