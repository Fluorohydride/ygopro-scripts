--グランドレミコード・クーリア
---@param c Card
function c84521924.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c84521924.lcheck)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c84521924.atkval)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c84521924.effectfilter)
	c:RegisterEffect(e2)
	--Effect 3
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84521924,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c84521924.spcon)
	e4:SetTarget(c84521924.sptg)
	e4:SetOperation(c84521924.spop)
	c:RegisterEffect(e4)
end
function c84521924.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c84521924.atkval(e,c)
	local ct=Duel.GetMatchingGroupCount(aux.AND(Card.IsFaceup,Card.IsType),e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil,TYPE_PENDULUM)
	return ct*100
end
function c84521924.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local lg=e:GetHandler():GetLinkedGroup()
	local te,loc,seq,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_PENDULUM) and bit.band(loc,LOCATION_MZONE)~=0 and bit.extract(e:GetHandler():GetLinkedZone(),seq)~=0 and p==tp
end
function c84521924.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c84521924.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x162) and c:GetCurrentScale()%2==1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c84521924.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return Duel.IsExistingMatchingCard(c84521924.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c84521924.tefilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:GetCurrentScale()%2==0
end
function c84521924.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(c84521924.spfilter,tp,LOCATION_PZONE,0,nil,e,tp,zone)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 or Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)==0 then return end
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(c84521924.tefilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(84521924,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(84521924,2))
		local exg=Duel.SelectMatchingCard(tp,c84521924.tefilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoExtraP(exg,nil,REASON_EFFECT)
	end
end
