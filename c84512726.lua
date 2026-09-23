--セネトの啓示者－ネフェルタリ
local s,id,o=GetID()
function s.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.setcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.eqcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.chkfilter(c)
	return c:IsFaceupEx() and c:IsAllCardTypes(TYPE_NORMAL+TYPE_MONSTER)
end
function s.setfilter(c)
	return c:IsSetCard(0x1eb) and c:IsSSetable() and c:IsType(TYPE_SPELL)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.gcheck(g,ft,res)
	return (g:FilterCount(aux.NOT(Card.IsType),nil,TYPE_FIELD)<=ft-1 or res)
		and g:FilterCount(Card.IsType,nil,TYPE_FIELD)<=1
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>=2 then ft=2 end
	local res=true
	if g:IsExists(Card.IsType,1,nil,TYPE_FIELD) and ft<2 then
		ft=ft+1
		res=false
	end
	local cg=Duel.GetMatchingGroup(s.chkfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_DECK,0,nil)
	local dt=g:GetCount()
	if dt>1 and not g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_FIELD) then dt=1 end
	local ct=math.min(ft,dt,cg:GetCount())
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rg=cg:Select(tp,1,ct,nil)
	if rg:GetCount()>0 then
		local hg=rg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_DECK)
		local og=rg-hg
		Duel.ConfirmCards(1-tp,hg)
		Duel.HintSelection(og)
		if hg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
			Duel.ShuffleHand(tp)
		end
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:SelectSubGroup(tp,s.gcheck,false,rg:GetCount(),rg:GetCount(),ft,res)
			if sg:GetCount()>0 then
				Duel.SSet(tp,sg)
			end
		end
	end
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.eqfilter(c,tp)
	return  c:IsType(TYPE_NORMAL) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(s.eqtgfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.eqtgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if ec then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tc=Duel.SelectMatchingCard(tp,s.eqtgfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			if not Duel.Equip(tp,ec,tc) then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(tc)
			e1:SetValue(s.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
