--覇王眷竜スターヴ・ヴェノム
function c43387895.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c43387895.ffilter,2,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c43387895.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c43387895.spcon)
	e2:SetOperation(c43387895.spop)
	c:RegisterEffect(e2)
	--copy effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43387895,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c43387895.copycost)
	e3:SetTarget(c43387895.copytg)
	e3:SetOperation(c43387895.copyop)
	c:RegisterEffect(e3)
end
function c43387895.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsFusionType(TYPE_PENDULUM)
end
function c43387895.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c43387895.spfilter(c,fc)
	return c43387895.ffilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c43387895.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCountFromEx(tp,PLAYER_NONE)
	local ct=-ft+1
	local g=Duel.GetReleaseGroup(tp):Filter(c43387895.spfilter,nil,c)
	return g:GetCount()>1 and (Duel.GetLocationCountFromEx(tp)>0 or g:IsExists(Card.CheckMZoneFromEx,ct,nil,tp))
end
function c43387895.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCountFromEx(tp,PLAYER_NONE)
	local ct=-ft+1
	local g=Duel.GetReleaseGroup(tp):Filter(c43387895.spfilter,nil,c)
	local sg=nil
	if Duel.GetLocationCountFromEx(tp)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:FilterSelect(tp,Card.CheckMZoneFromEx,ct,ct,nil,tp)
		if ct<2 then
			g:Sub(sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g1=g:Select(tp,2-ct,2-ct,nil)
			sg:Merge(g1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		sg=g:Select(tp,2,2,nil)
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c43387895.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(41209827)==0 end
	e:GetHandler():RegisterFlagEffect(41209827,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c43387895.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c43387895.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c43387895.copyfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c43387895.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c43387895.copyfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
end
function c43387895.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and (tc:IsFaceup() or tc:IsLocation(LOCATION_GRAVE)) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(43387895,1))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetCountLimit(1)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e3:SetLabelObject(e1)
			e3:SetLabel(cid)
			e3:SetOperation(c43387895.rstop)
			c:RegisterEffect(e3)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c43387895.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then c:ResetEffect(cid,RESET_COPY) end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
