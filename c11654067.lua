--ファイヤー・エジェクション
---@param c Card
function c11654067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11654067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c11654067.target)
	e1:SetOperation(c11654067.activate)
	c:RegisterEffect(e1)
end
function c11654067.tgfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsAbleToGrave()
end
function c11654067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11654067.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c11654067.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11654067.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsSetCard(0x32) then
		local b1=tc:GetLevel()>0
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,11654068,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_PYRO,ATTRIBUTE_FIRE,POS_FACEUP,1-tp)
		local sel=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(11654067,0)},
			{b2,aux.Stringid(11654067,1)},
			{true,aux.Stringid(11654067,2)})
		if sel==1 then
			Duel.BreakEffect()
			local val=tc:GetLevel()*100
			Duel.Damage(1-tp,val,REASON_EFFECT)
		elseif sel==2 then
			Duel.BreakEffect()
			local token=Duel.CreateToken(tp,11654068)
			if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_LEAVE_FIELD)
				e1:SetOperation(c11654067.damop)
				token:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c11654067.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(c:GetPreviousControler(),500,REASON_EFFECT)
	end
	e:Reset()
end
