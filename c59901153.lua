--胡蝶姉妹
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	return g1:GetSum(Card.GetLevel)<=g2:GetSum(Card.GetLevel)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.thfilter(c)
	return c:IsLevelAbove(7) and c:IsRace(RACE_INSECT+RACE_PLANT) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(s.regop)
		e1:SetLabel(g:GetFirst():GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetCondition(s.damcon)
		e3:SetOperation(s.damop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetLabelObject(e2)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local tc=eg:GetFirst()
	if tc:IsSummonPlayer(tp) and tc:IsCode(e:GetLabel()) then
		e:SetLabel(0)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local lo=e:GetLabelObject()
	return lo:GetLabel()~=0 and lo:GetLabelObject():GetLabel()~=0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(tp,2700,REASON_EFFECT)
end
