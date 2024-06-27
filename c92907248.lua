--ウェイクアップ・センチュリオン！
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local t1=Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x1a2,TYPES_TOKEN_MONSTER,0,0,4,RACE_PYRO,ATTRIBUTE_DARK)
	local t2=Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x1a2,TYPES_TOKEN_MONSTER,0,0,8,RACE_PYRO,ATTRIBUTE_DARK)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		(t1 or t2) end
	local lv=0
	if t1 and t2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		e:SetLabel(Duel.AnnounceLevel(tp,4,8,5,6,7))
	elseif t1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		e:SetLabel(Duel.AnnounceLevel(tp,4,4))
	elseif t2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		e:SetLabel(Duel.AnnounceLevel(tp,8,8))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0x1a2,TYPES_TOKEN_MONSTER,0,0,lv,RACE_PYRO,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,id+o)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(lv)
	token:RegisterEffect(e1,true)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetValue(1)
	token:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token:RegisterEffect(e5)
	Duel.SpecialSummonComplete()
end
function s.tgfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0x1a2) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end