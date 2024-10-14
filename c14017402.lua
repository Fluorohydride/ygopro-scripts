--波動竜騎士 ドラゴエクィテス
local s,id,o=GetID()
---@param c Card
function c14017402.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c14017402.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),true)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14017402,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c14017402.target)
	e2:SetOperation(c14017402.operation)
	c:RegisterEffect(e2)
	--reflect damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REFLECT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c14017402.refcon)
	c:RegisterEffect(e3)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c14017402.splimit)
	c:RegisterEffect(e4)
end
c14017402.material_type=TYPE_SYNCHRO
function c14017402.splimit(e,se,sp,st)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	return true
end
function c14017402.refcon(e,re,val,r,rp,rc)
	return bit.band(r,REASON_EFFECT)~=0 and rp==1-e:GetHandler():GetControler() and e:GetHandler():IsAttackPos()
end
function c14017402.ffilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFusionType(TYPE_SYNCHRO)
end
function c14017402.cpfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove()
end
function c14017402.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c14017402.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14017402.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c14017402.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c14017402.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsRace(RACE_DRAGON) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==1 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		local reset_flag=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(reset_flag)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		--copy effect
		local cid=c:CopyEffect(code,reset_flag,1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1162)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetLabel(cid)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.rstop)
		c:RegisterEffect(e2)
	end
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
