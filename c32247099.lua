--絶対なる幻神獣
---@param c Card
function c32247099.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32247099,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,32247099)
	e2:SetCondition(c32247099.spcon)
	e2:SetCost(c32247099.spcost)
	e2:SetTarget(c32247099.sptg)
	e2:SetOperation(c32247099.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32247099,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,32247100)
	e3:SetCondition(c32247099.descon)
	e3:SetTarget(c32247099.destg)
	e3:SetOperation(c32247099.desop)
	c:RegisterEffect(e3)
	if not c32247099.global_check then
		c32247099.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c32247099.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c32247099.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c32247099.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		local ct=rc:GetFlagEffectLabel(32247099)
		if not ct then
			rc:RegisterFlagEffect(32247099,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		else
			rc:SetFlagEffectLabel(32247099,ct+1)
		end
	end
end
function c32247099.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local ct=rc:GetFlagEffectLabel(32247099)
	if ct==1 then
		rc:ResetFlagEffect(32247099)
	elseif ct then
		rc:SetFlagEffectLabel(32247099,ct-1)
	end
end
function c32247099.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c32247099.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c32247099.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32247099.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c32247099.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c32247099.spfilter(c,e,tp)
	return c:IsRace(RACE_DIVINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c32247099.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c32247099.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c32247099.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c32247099.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c32247099.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0
		and not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.BreakEffect()
		Duel.ChangeAttackTarget(tc)
	end
end
function c32247099.descfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DIVINE)
end
function c32247099.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c32247099.descfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c32247099.desfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(32247099)>0
end
function c32247099.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c32247099.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c32247099.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32247099.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
