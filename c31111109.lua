--E・HERO ゴッド・ネオス
function c31111109.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c31111109.fuscon)
	e1:SetOperation(c31111109.fusop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31111109,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c31111109.copytg)
	e2:SetOperation(c31111109.copyop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.fuslimit)
	c:RegisterEffect(e3)
end
c31111109.material_setcode=0x8
function c31111109.ffilter(c,fc)
	return (c:IsFusionSetCard(0x9) or c:IsFusionSetCard(0x1f) or c:IsFusionSetCard(0x8))
		and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c31111109.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res
	if sg:GetCount()<5 then
		res=mg:IsExists(c31111109.fselect,1,sg,tp,mg,sg)
	else
		res=c31111109.fgoal(tp,sg)
	end
	sg:RemoveCard(c)
	return res
end
function c31111109.fgoal(tp,sg)
	if sg:IsExists(aux.FCheckTuneMagicianX,1,nil,sg) then return false end
	if not (sg:GetCount()==5 and Duel.GetLocationCountFromEx(tp,tp,sg)>0) then return false end
	local g1=sg:Filter(Card.IsFusionSetCard,nil,0x9)
	local c1=g1:GetCount()
	local g2=sg:Filter(Card.IsFusionSetCard,nil,0x1f)
	local c2=g2:GetCount()
	local g3=sg:Filter(Card.IsFusionSetCard,nil,0x8)
	local c3=g3:GetCount()
	return c1>0 and c2>0 and c3>0 and (c1>1 or c3>1 or g1:GetFirst()~=g3:GetFirst())
end
function c31111109.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local tp=c:GetControler()
	local mg=g:Filter(c31111109.ffilter,nil,c)
	if gc then
		if not mg:IsContains(gc) then return false end
		local sg=Group.CreateGroup()
		return c31111109.fselect(gc,tp,mg,sg)
	end
	local sg=Group.CreateGroup()
	return mg:IsExists(c31111109.fselect,1,nil,tp,mg,sg)
end
function c31111109.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local mg=eg:Filter(c31111109.ffilter,nil,c)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	while sg:GetCount()<5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,c31111109.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	Duel.SetFusionMaterial(sg)
end
function c31111109.filter(c)
	return (c:IsSetCard(0x9) or c:IsSetCard(0x1f) or c:IsSetCard(0x8)) and c:IsType(TYPE_MONSTER)
		and not c:IsForbidden() and c:IsAbleToRemove()
end
function c31111109.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31111109.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31111109.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c31111109.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c31111109.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then return end
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(31111109,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabel(cid)
		e2:SetOperation(c31111109.rstop)
		c:RegisterEffect(e2)
	end
end
function c31111109.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
