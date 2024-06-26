--怒小児様
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(s.ovtg)
	e1:SetOperation(s.ovop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	e2:SetCondition(s.effcon)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	e4:SetCondition(s.effcon)
	e4:SetLabel(4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.effcon)
	e6:SetCost(s.descost)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	e6:SetLabel(8)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(s.negcheck)
		ge1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.negcheck(e,tp,eg,ep,ev,re,r,rp)
	local de=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON)
	if de then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,de,0,tp,tp,0)
	end
end
function s.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
end
function s.gchecktp(c,tp)
	return c:GetOwner()==tp
end
function s.gcheck(g,tp)
	return g:FilterCount(s.gchecktp,nil,tp)<=1 and g:FilterCount(s.gchecktp,nil,1-tp)<=1
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ofilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g:SelectSubGroup(tp,s.gcheck,false,1,2,tp)
			if sg:GetCount()>0 then
				Duel.HintSelection(sg)
				Duel.Overlay(c,sg)
			end
		end
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function s.atkval(e,c)
	return c:GetOverlayCount()*700
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,4,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,4,4,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end