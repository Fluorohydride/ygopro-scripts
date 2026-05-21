--超越召喚獣アイオーン
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(s.FSCondition)
	e0:SetOperation(s.FSOperation)
	c:RegisterEffect(e0)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--att
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.atttg)
	e2:SetOperation(s.attop)
	c:RegisterEffect(e2)
end
function s.FSFilter(c,fc)
	return c:IsType(TYPE_FUSION) and c:IsCanBeFusionMaterial(fc)
end
function s.FSFilter1(g,fc,gc,tp,chkf)
	if gc and not g:IsContains(gc) then return false end
	if g:IsExists(aux.TuneMagicianCheckX,1,nil,g,EFFECT_TUNE_MAGICIAN_F) then return false end
	if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_FMATERIAL) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,g,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,g,fc) then return false end
	return chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
end
function s.FSCondition(e,g,gc,chkf)
	if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
	local c=e:GetHandler()
	local mg=g:Filter(s.FSFilter,nil,c)
	local tp=e:GetHandlerPlayer()
	local res=false
	aux.GCheckAdditional=aux.dabcheck
	if gc then
		if not mg:IsContains(gc) then
			aux.GCheckAdditional=nil
			return false
		end
		res=mg:CheckSubGroup(s.FSFilter1,2,99,c,gc,tp,chkf)
	else
		res=mg:CheckSubGroup(s.FSFilter1,2,99,c,nil,tp,chkf)
	end
	aux.GCheckAdditional=nil
	return res
end
function s.FSOperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(s.FSFilter,nil,c)
	aux.GCheckAdditional=aux.dabcheck
	local g=nil
	while not g do
		if gc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g=mg:SelectSubGroup(tp,s.FSFilter1,true,2,99,c,gc,tp,chkf)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g=mg:SelectSubGroup(tp,s.FSFilter1,true,2,99,c,nil,tp,chkf)
		end
	end
	aux.GCheckAdditional=nil
	Duel.SetFusionMaterial(g)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if ct>2 then
		e:SetLabel(ct,1)
	else
		e:SetLabel(ct,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ct,res=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0
			and res==1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			Duel.ConfirmCards(tp,g,true)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=g:FilterSelect(tp,Card.IsAbleToRemove,1,3,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			Duel.ShuffleExtra(1-tp)
		end
	end
end
function s.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local att=0
	for tc in aux.Next(g) do
		att=bit.bor(att,(0x7f-tc:GetAttribute()))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local ratt=Duel.AnnounceAttribute(tp,1,att)
	e:SetLabel(ratt)
end
function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
