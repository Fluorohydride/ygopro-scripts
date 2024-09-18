--原石の号咆
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Get Control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.gccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.gctg)
	e2:SetOperation(s.gcop)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_NORMAL,OPCODE_ISTYPE,5405694,OPCODE_ISCODE,OPCODE_OR,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function s.smfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.ptfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(code)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.smfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,code)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.smfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,code)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end
function s.ptfilter(e,c)
	return c:IsSetCard(0x1b9) or (c:IsCode(e:GetLabel()) and c:IsType(TYPE_NORMAL))
end
function s.gccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function s.gcfilter1(c,tp)
	return c:IsType(TYPE_NORMAL) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.gcfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function s.gcfilter2(c,atk)
	return c:IsFaceup() and c:GetAttack()>atk and c:IsControlerCanBeChanged()
end
function s.gctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and s.gcfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.gcfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	aux.SelectTargetFromFieldFirst(tp,s.gcfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function s.gcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetTargetsRelateToChain():GetFirst()
	if tc and tc:IsFaceup() and tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.gcfilter2,tp,0,LOCATION_MZONE,1,nil,tc:GetAttack()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,s.gcfilter2,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack())
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
		end
	end
end
