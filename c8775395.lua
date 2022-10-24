--災誕の呪眼
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.eqcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
end
function s.tgfilter(c)
	return c:IsSetCard(0x129) and c:IsAbleToGraveAsCost()
end
function s.thfilter(c)
	return c:IsSetCard(0x129) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.gcheck(g,tp)
	return aux.gfcheck(g,Card.IsType,TYPE_MONSTER,TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,g)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(s.gcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,2,2,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		or Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	--lose lp
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(s.lpop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp and not re:GetHandler():IsSetCard(0x129) then
		Duel.SetLP(tp,Duel.GetLP(tp)-500)
	end
end
function s.cfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x129) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsSummonPlayer(tp)
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.eqfilter(c,tp)
	return c:IsSetCard(0x129) and c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(s.eqtgfilter,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.eqtgfilter(c,eqc)
	return c:IsFaceup() and c:IsSetCard(0x129) and c:IsType(TYPE_LINK) and eqc:CheckEquipTarget(c)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,s.eqtgfilter,tp,LOCATION_MZONE,0,1,1,nil,ec):GetFirst()
			Duel.Equip(tp,ec,tc)
		end
	end
end
