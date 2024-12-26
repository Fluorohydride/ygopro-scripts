--小天使テルス
---@param c Card
function c19280589.initial_effect(c)
	--Special Summon 1 Token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19280589,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,19280589)
	e1:SetCondition(c19280589.tkcon1)
	e1:SetTarget(c19280589.tktg1)
	e1:SetOperation(c19280589.tkop1)
	c:RegisterEffect(e1)
	--Special Summon 2 Token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19280589,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19280590)
	e2:SetCost(c19280589.tkcost2)
	e2:SetCondition(c19280589.tkcon2)
	e2:SetTarget(c19280589.tktg2)
	e2:SetOperation(c19280589.tkop2)
	c:RegisterEffect(e2)
end
function c19280589.tkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c19280589.tktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,19280590,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c19280589.tkop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,19280590,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,19280590)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19280589.tkcsfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c19280589.tkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c19280589.tkcsfilter,tp,LOCATION_HAND,0,1,c) and c:IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c19280589.tkcsfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c19280589.ctkfilter(c)
	return c:IsFaceup() and c:IsCode(19280590)
end
function c19280589.tkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19280589.ctkfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c19280589.tktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,19280590,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c19280589.tkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,19280590,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,19280590)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c19280589.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19280589.splimit(e,c)
	return not c:IsLocation(LOCATION_HAND)
end
