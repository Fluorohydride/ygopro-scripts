--禁呪アラマティア
---@param c Card
function c34690953.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34690953,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,34690953)
	e2:SetCost(c34690953.tkcost)
	e2:SetTarget(c34690953.tktg)
	e2:SetOperation(c34690953.tkop)
	c:RegisterEffect(e2)
	--token if monster destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(34690953,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,34690954)
	e3:SetCondition(c34690953.spcon)
	e3:SetTarget(c34690953.sptg)
	e3:SetOperation(c34690953.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(34690953,ACTIVITY_SPSUMMON,c34690953.counterfilter)
end
function c34690953.counterfilter(c)
	return aux.IsCodeOrListed(c,3285552)
end
function c34690953.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(34690953,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c34690953.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c34690953.splimit(e,c)
	return not c34690953.counterfilter(c)
end
function c34690953.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	if chk==0 then return (b1 or b2)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c34690953.tkop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	local sel=0
	if b1 or b2 then
		if b1 and b2 then
			sel=Duel.SelectOption(tp,aux.Stringid(34690953,2),aux.Stringid(34690953,3))
		elseif b2 then
			sel=1
		end
		local to=tp
		if sel==1 then to=1-tp end
		local token=Duel.CreateToken(tp,34690954)
		if Duel.SpecialSummon(token,0,tp,to,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function c34690953.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c34690953.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c34690953.cfilter,1,nil,tp)
end
function c34690953.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,0)
end
function c34690953.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	local sel=0
	if b1 or b2 then
		if b1 and b2 then
			sel=Duel.SelectOption(tp,aux.Stringid(34690953,2),aux.Stringid(34690953,3))
		elseif b2 then
			sel=1
		end
		local to=tp
		if sel==1 then to=1-tp end
		local token=Duel.CreateToken(tp,34690954)
		Duel.SpecialSummon(token,0,tp,to,false,false,POS_FACEUP)
	end
end
