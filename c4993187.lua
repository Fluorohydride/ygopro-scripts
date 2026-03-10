--W：Pファンシーボール
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.lkcon)
	e2:SetTarget(s.lktg)
	e2:SetOperation(s.lkop)
	c:RegisterEffect(e2)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (LOCATION_ONFIELD+LOCATION_GRAVE)&loc~=0
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	if re:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToChain(ev) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsMainPhase()
end
function s.lkfilter(c)
	return c:IsLinkSummonable(nil)
end
function s.mattg(e,c)
	return c:IsFaceup() and c:IsLinkBelow(2)
end
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local le=Effect.CreateEffect(c)
	le:SetType(EFFECT_TYPE_FIELD)
	le:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	le:SetTargetRange(0,LOCATION_MZONE)
	le:SetLabel(fid)
	le:SetLabelObject(c)
	le:SetTarget(s.mattg)
	le:SetValue(s.matval)
	Duel.RegisterEffect(le,tp)
	local res=Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil)
	le:Reset()
	c:ResetFlagEffect(id)
	if chk==0 then return res end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return not e:GetHandler():IsAllTypes(TYPE_LINK+TYPE_MONSTER)
end
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsControler(tp) and c:IsFaceup() then
		local fid=c:GetFieldID()
		local le=Effect.CreateEffect(c)
		le:SetType(EFFECT_TYPE_FIELD)
		le:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		le:SetTargetRange(0,LOCATION_MZONE)
		le:SetLabel(fid)
		le:SetLabelObject(c)
		le:SetTarget(s.mattg)
		le:SetValue(s.matval)
		le:SetReset(RESET_PHASE+PHASE_MAIN1+PHASE_MAIN2)
		Duel.RegisterEffect(le,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end

function s.matval(e,lc,mg,c,tp)
	local wp=e:GetLabelObject()
	local fid=e:GetLabel()
	if wp:GetFieldID()~=fid then return false,nil end

	-- W：Pファンシーボール must be controlled by tp to provide its material effect
	if wp:GetControler()~=tp then
		return false,nil
	end

	-- W：Pファンシーボール only relates to opponent face-up Link<=2
	if not s.wp_eligible_opp_link2(c,tp) then
		return false,nil
	end

	-- W：Pファンシーボール must actually be used in the material group
	if not mg or not mg:IsContains(wp) then
		return true,false
	end

	-- Explicit: W：Pファンシーボール provides at most ONE opponent Link<=2.
	-- If mg already contains another opponent Link<=2 (besides this candidate), W：Pファンシーボール will not provide it.
	if mg:IsExists(s.wp_eligible_opp_link2,1,c,tp) then
		return true,false
	end

	return true,true
end

function s.wp_eligible_opp_link2(c,tp)
	return c:IsControler(1-tp) and c:IsFaceup() and c:IsLinkBelow(2)
end
