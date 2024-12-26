--空牙団の闘士 ブラーヴォ
---@param c Card
function c66740005.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66740005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,66740005)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c66740005.sptg)
	e1:SetOperation(c66740005.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66740005,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66740006)
	e2:SetCondition(c66740005.atkcon)
	e2:SetTarget(c66740005.atktg)
	e2:SetOperation(c66740005.atkop)
	c:RegisterEffect(e2)
end
function c66740005.spfilter(c,e,tp)
	return c:IsSetCard(0x114) and not c:IsCode(66740005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c66740005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c66740005.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c66740005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c66740005.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c66740005.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x114) and c:IsControler(tp)
end
function c66740005.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c66740005.cfilter,1,nil,tp)
end
function c66740005.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x114)
end
function c66740005.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66740005.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c66740005.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c66740005.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if tg:GetCount()>0 then
		local sc=tg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(500)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=tg:GetNext()
		end
	end
end
