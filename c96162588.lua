--六花の風花
function c96162588.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--release
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96162588,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,96162588)
	e1:SetCondition(c96162588.rlcon)
	e1:SetTarget(c96162588.rltg)
	e1:SetOperation(c96162588.rlop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96162588,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c96162588.descon)
	e2:SetTarget(c96162588.destg)
	e2:SetOperation(c96162588.desop)
	c:RegisterEffect(e2)
end
function c96162588.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousSetCard(0x141)
end
function c96162588.rlcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c96162588.cfilter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c96162588.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(1-tp,nil,1,REASON_RULE,false,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
end
function c96162588.rlop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectReleaseGroupEx(1-tp,nil,1,1,REASON_RULE,false,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Release(g,REASON_RULE,1-tp)
	end
end
function c96162588.desfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_PLANT)
end
function c96162588.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return Duel.GetTurnPlayer()==1-tp and g:IsExists(c96162588.desfilter,1,nil)
end
function c96162588.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c96162588.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
